unit controller.cep.uViaCepController;

interface

uses
  controller.cep.uIViaCepController,

  System.Net.HttpClient,
  System.JSON,
  System.SysUtils, model.cep.uIViaCEP;

type
  TViaCepController = class(TInterfacedObject, IViaCepController)
  public
    class function New: IViaCepController;
    function ConsultarPorCEP(const ACep: string): IViaCep;
  end;

implementation

uses
  model.cep.uViaCEP;

function SomenteDigitos(const ATexto: string): string;
var
  lChar: Char;
begin
  Result := '';
  for lChar in ATexto do
    if CharInSet(lChar, ['0'..'9']) then
      Result := Result + lChar;
end;

function TextoJson(AJson: TJSONObject; const ACampo: string): string;
var
  lValor: TJSONValue;
begin
  Result := '';
  if not Assigned(AJson) then
    Exit;

  lValor := AJson.GetValue(ACampo);
  if (lValor = nil) or (lValor is TJSONNull) then
    Exit;

  Result := lValor.Value;
end;

function TViaCepController.ConsultarPorCEP(const ACep: string): IViaCep;
var
  HttpClient: THttpClient;
  Response: IHTTPResponse;
  JsonValor: TJSONValue;
  JsonObj: TJSONObject;
  lCep: string;
begin
  lCep := SomenteDigitos(ACep);
  if Length(lCep) <> 8 then
    raise Exception.Create('CEP inválido.');

  HttpClient := THttpClient.Create;
  JsonValor := nil;
  try
    try
      Response := HttpClient.Get('https://viacep.com.br/ws/' + lCep + '/json/');
      if Response.StatusCode <> 200 then
        raise Exception.Create('Não foi possível consultar o CEP.');

      JsonValor := TJSONObject.ParseJSONValue(Response.ContentAsString);
      if not (JsonValor is TJSONObject) then
        raise Exception.Create('Resposta inválida ao consultar o CEP.');

      JsonObj := TJSONObject(JsonValor);
      if JsonObj.GetValue('erro') <> nil then
        raise Exception.Create('CEP inválido.');

      Result := TViaCep.Create
        .SetCep(TextoJson(JsonObj, 'cep'))
        .SetLogradouro(TextoJson(JsonObj, 'logradouro'))
        .SetComplemento(TextoJson(JsonObj, 'complemento'))
        .SetBairro(TextoJson(JsonObj, 'bairro'))
        .SetCidade(TextoJson(JsonObj, 'localidade'))
        .SetUF(TextoJson(JsonObj, 'uf'))
        .SetCodigoIBGE(TextoJson(JsonObj, 'ibge'));
    except
      on E: Exception do
      begin
        if (E.Message = 'CEP inválido.') or
           (E.Message = 'Não foi possível consultar o CEP.') or
           (E.Message = 'Resposta inválida ao consultar o CEP.') then
          raise;

        raise Exception.Create('Não foi possível consultar o CEP.');
      end;
    end;
  finally
    JsonValor.Free;
    HttpClient.Free;
  end;
end;

class function TViaCepController.New: IViaCepController;
begin
  Result := Self.Create;
end;

end.
