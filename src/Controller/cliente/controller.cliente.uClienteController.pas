unit controller.cliente.uClienteController;

interface

uses
  controller.cliente.uIClienteController,
  controller.uIController,
  model.cliente.uICliente,
  model.entity.uIEntity,
  model.dao.uIDao;

type
  TClienteController = class(TInterfacedObject, IClienteController)
  private
    FEntity: IEntity;
    FDao: TFabricaDao;
    constructor Create(const AEntity: IEntity; const ADao: TFabricaDao);
    function Materializar(ADao: IDao): TArray<ICliente>;
  public
    class function New(const AEntity: IEntity; const ADao: TFabricaDao): IClienteController;
    function Novo: ICliente;
    function Buscar(ACodigo: Integer): ICliente;
    function Listar: TArray<ICliente>;
    function PesquisarPorNome(const ANome: string): TArray<ICliente>;
    procedure Salvar(ACliente: ICliente);
    procedure Excluir(ACodigo: Integer);
  end;

implementation

uses
  Data.DB,
  model.validacao.uValidacao,
  utils.uMapeador;

constructor TClienteController.Create(const AEntity: IEntity; const ADao: TFabricaDao);
begin
  FEntity := AEntity;
  FDao := ADao;
end;

class function TClienteController.New(const AEntity: IEntity; const ADao: TFabricaDao): IClienteController;
begin
  Result := Self.Create(AEntity, ADao);
end;

function TClienteController.Novo: ICliente;
begin
  Result := FEntity.Cliente;
end;

function TClienteController.Buscar(ACodigo: Integer): ICliente;
var
  lDao: IDao;
begin
  Result := Novo.SetCodigo(ACodigo);
  lDao := FDao(Result, nil).ListarPorId;
  if lDao.Encontrou then
    lDao.Materializar;
end;

function TClienteController.Materializar(ADao: IDao): TArray<ICliente>;
var
  lConsulta: TDataSet;
  lCliente: ICliente;
begin
  Result := nil;
  lConsulta := ADao.Consulta;
  if not Assigned(lConsulta) or lConsulta.IsEmpty then
    Exit;

  lConsulta.First;
  while not lConsulta.Eof do
  begin
    lCliente := Novo;
    TMapeador.Preencher(TObject(lCliente), lConsulta);
    Result := Result + [lCliente];
    lConsulta.Next;
  end;
end;

function TClienteController.Listar: TArray<ICliente>;
begin
  Result := Materializar(FDao(Novo, nil).Listar);
end;

function TClienteController.PesquisarPorNome(const ANome: string): TArray<ICliente>;
begin
  Result := Materializar(FDao(Novo.SetNome(ANome), nil).ListarContendo('NOME'));
end;

procedure TClienteController.Salvar(ACliente: ICliente);
begin
  ACliente.Validar;
  if ACliente.GetCodigo <= 0 then
    FDao(ACliente, nil).Inserir
  else
    FDao(ACliente, nil).Atualizar;
end;

procedure TClienteController.Excluir(ACodigo: Integer);
var
  lDao: IDao;
begin
  lDao := FDao(FEntity.Pedido.SetCodigoCliente(ACodigo), nil).ListarPor('CODIGO_CLIENTE');
  if lDao.Encontrou then
    raise EValidacao.Create(
      'CODIGO',
      'Cliente vínculado a um pedido não pode ser excluído.'
    );

  FDao(Novo.SetCodigo(ACodigo), nil).Excluir;
end;

end.
