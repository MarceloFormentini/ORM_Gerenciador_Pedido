unit model.conexao.uConnectionFiredac;

interface

uses
  model.conexao.uIConnection,
  System.SysUtils,
  FireDAC.Comp.Client,
  FireDAC.Phys.FB,
  FireDAC.Stan.Def,
  FireDAC.DApt,
  FireDAC.VCLUI.Wait,
  FireDAC.Stan.Async,
  model.conexao.uIQuery;

type
  TConnectionFiredac = class(TInterfacedObject, IConnection)
  private
    FConnection: TFDConnection;

    class procedure GarantirPool;
    constructor Create;
    destructor Destroy; override;

  public
    class function New: IConnection;
    function CriarConsulta: IQuery;
    procedure IniciarTransacao;
    procedure ConfirmarTransacao;
    procedure CancelarTransacao;
  end;

implementation

uses
  model.conexao.uISettings,
  model.conexao.uSettings,
  model.conexao.uQuery,
  FireDAC.Stan.Intf;

const
  NOME_POOL = 'PEDIDO_POOL';

class procedure TConnectionFiredac.GarantirPool;
var
  lDefinicao: IFDStanConnectionDef;
  lSettings: ISettings;
begin
  if FDManager.ConnectionDefs.FindConnectionDef(NOME_POOL) <> nil then
    Exit;

  lSettings := TSettings.New(ExtractFilePath(ParamStr(0)) + 'conf.ini');
  lDefinicao := FDManager.ConnectionDefs.AddConnectionDef;
  lDefinicao.Name := NOME_POOL;
  lDefinicao.Params.DriverID := lSettings.GetDriverName;
  lDefinicao.Params.Database := lSettings.GetCaminho;
  lDefinicao.Params.UserName := lSettings.GetUsuario;
  lDefinicao.Params.Password := lSettings.GetSenha;
  lDefinicao.Params.Pooled := True;
  if not lSettings.GetServidor.Trim.IsEmpty then
  begin
    lDefinicao.Params.Values['Server'] := lSettings.GetServidor;
    lDefinicao.Params.Values['Port'] := lSettings.GetPorta;
    lDefinicao.Params.Values['Protocol'] := 'TCPIP';
  end;
end;

function TConnectionFiredac.CriarConsulta: IQuery;
begin
  Result := TQuery.New(FConnection);
end;

procedure TConnectionFiredac.IniciarTransacao;
begin
  if not FConnection.Connected then
    FConnection.Connected := True;

  if not FConnection.InTransaction then
    FConnection.StartTransaction;
end;

procedure TConnectionFiredac.ConfirmarTransacao;
begin
  if FConnection.InTransaction then
    FConnection.Commit;
end;

procedure TConnectionFiredac.CancelarTransacao;
begin
  if FConnection.InTransaction then
    FConnection.Rollback;
end;

constructor TConnectionFiredac.Create;
begin
  try
    GarantirPool;
    FConnection := TFDConnection.Create(nil);
    FConnection.LoginPrompt := False;
    FConnection.ConnectionDefName := NOME_POOL;
  except
    on E: Exception do
      Exception.RaiseOuterException(
        Exception.Create('Error ao tentar conectar com a base de dados. ' + E.Message));
  end;
end;

destructor TConnectionFiredac.Destroy;
begin
  FConnection.Free;
  inherited;
end;

class function TConnectionFiredac.New: IConnection;
begin
  Result := Self.Create;
end;

end.
