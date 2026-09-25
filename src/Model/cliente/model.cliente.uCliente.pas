unit model.cliente.uCliente;

interface

uses
  model.cliente.uICliente,
  utils.uAtributos;

type
  [Tabela('CLIENTE')]
  TCliente = class(TInterfacedObject, ICliente)
  private
    [Campo('CODIGO'), PK, Identidade]
    FCodigo: Integer;

    [Campo('NOME')]
    FNome: string;

    [Campo('CEP')]
    FCep: String;

    [Campo('LOGRADOURO')]
    FLogradouro: String;

    [Campo('COMPLEMENTO')]
    FComplemento: String;

    [Campo('BAIRRO')]
    FBairro: String;

    [Campo('CIDADE')]
    FCidade: string;

    [Campo('UF')]
    FUF: string;

    [Campo('CODIGO_IBGE')]
    FCodigoIBGE: String;

  public
    class function New: ICliente;

    function GetCodigo: Integer;
    function GetNome: string;
    function GetCEP: string;
    function GetLogradouro: string;
    function GetComplemento: string;
    function GetBairro: string;
    function GetCidade: string;
    function GetUF: string;
    function GetCodigoIBGE: string;

    function SetCodigo(const AValue: Integer): ICliente;
    function SetNome(const AValue: string): ICliente;
    function SetCEP(const AValue: string): ICliente;
    function SetLogradouro(const AValue: string): ICliente;
    function SetComplemento(const AValue: string): ICliente;
    function SetBairro(const AValue: string): ICliente;
    function SetCidade(const AValue: string): ICliente;
    function SetUF(const AValue: string): ICliente;
    function SetCodigoIBGE(const AValue: string): ICliente;

    procedure Validar;
  end;

implementation

uses
  System.SysUtils,
  model.validacao.uValidacao;

class function TCliente.New: ICliente;
begin
  Result := Self.Create;
end;

function TCliente.GetBairro: string;
begin
  Result := FBairro;
end;

function TCliente.GetCEP: string;
begin
  Result := FCEP;
end;

function TCliente.GetCidade: string;
begin
  Result := FCidade;
end;

function TCliente.GetCodigo: Integer;
begin
  Result := FCodigo;
end;

function TCliente.GetCodigoIBGE: string;
begin
  Result := FCodigoIBGE;
end;

function TCliente.GetComplemento: string;
begin
  Result := FComplemento;
end;

function TCliente.GetLogradouro: string;
begin
  Result := FLogradouro;
end;

function TCliente.GetNome: string;
begin
  Result := FNome;
end;

function TCliente.GetUF: string;
begin
  Result := FUF;
end;

function TCliente.SetBairro(const AValue: string): ICliente;
begin
  Result := Self;
  FBairro := AValue
end;

function TCliente.SetCEP(const AValue: string): ICliente;
begin
  Result := Self;
  FCEP := AValue
end;

function TCliente.SetCidade(const AValue: string): ICliente;
begin
  Result := Self;
  FCidade := AValue
end;

function TCliente.SetCodigo(const AValue: Integer): ICliente;
begin
  Result := Self;
  FCodigo := AValue;
end;

function TCliente.SetCodigoIBGE(const AValue: string): ICliente;
begin
  Result := Self;
  FCodigoIBGE := AValue
end;

function TCliente.SetComplemento(const AValue: string): ICliente;
begin
  Result := Self;
  FComplemento := AValue
end;

function TCliente.SetLogradouro(const AValue: string): ICliente;
begin
  Result := Self;
  FLogradouro := AValue
end;

function TCliente.SetNome(const AValue: string): ICliente;
begin
  Result := Self;
  FNome := AValue;
end;

function TCliente.SetUF(const AValue: string): ICliente;
begin
  Result := Self;
  FUF := AValue;
end;

procedure TCliente.Validar;
begin
  FNome := Trim(FNome);
  FCEP := Trim(FCEP);
  FLogradouro := Trim(FLogradouro);
  FBairro := Trim(FBairro);
  FCidade := Trim(FCidade);
  FUF := Trim(FUF);
  FCodigoIBGE := Trim(FCodigoIBGE);

  if FNome = '' then
    raise EValidacao.Create('NOME', 'O campo "Nome" é obrigatório.');
  if FCEP = '' then
    raise EValidacao.Create('CEP', 'O campo "CEP" é obrigatório.');
  if FLogradouro = '' then
    raise EValidacao.Create('LOGRADOURO', 'O campo "Logradouro" é obrigatório.');
  if FBairro = '' then
    raise EValidacao.Create('BAIRRO', 'O campo "Bairro" é obrigatório.');
  if FCidade = '' then
    raise EValidacao.Create('CIDADE', 'O campo "Cidade" é obrigatório.');
  if FUF = '' then
    raise EValidacao.Create('UF', 'O campo "UF" é obrigatório.');
  if FCodigoIBGE = '' then
    raise EValidacao.Create('CODIGO_IBGE', 'O campo "IBGE" é obrigatório.');
end;

end.
