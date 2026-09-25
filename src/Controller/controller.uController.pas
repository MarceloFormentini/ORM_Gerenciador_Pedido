unit controller.uController;

interface

uses
  controller.uIController,
  model.entity.uIEntity,
  controller.cliente.uIClienteController,
  controller.produto.uIProdutoController,
  controller.pedido.uIPedidoController;

type
  TController = class(TInterfacedObject, IController)
  private
    FEntity: IEntity;
    FDao: TFabricaDao;
    constructor Create(const AEntity: IEntity; const ADao: TFabricaDao);
  public
    class function New: IController; overload;
    class function New(const AEntity: IEntity; const ADao: TFabricaDao): IController; overload;
    function Entity: IEntity;
    function Clientes: IClienteController;
    function Produtos: IProdutoController;
    function Pedidos: IPedidoController;
  end;

implementation

uses
  model.entity.uEntity,
  model.cliente.uICliente,
  model.cliente.uCliente,
  model.produto.uIProduto,
  model.produto.uProduto,
  model.pedido.uIPedido,
  model.pedido.uPedido,
  model.pedidoItens.uIItensPedido,
  model.pedidoItens.uItensPedido,
  model.dao.uIDao,
  model.dao.uDao,
  model.conexao.uIConnection,
  controller.cliente.uClienteController,
  controller.produto.uProdutoController,
  controller.pedido.uPedidoController;

constructor TController.Create(const AEntity: IEntity; const ADao: TFabricaDao);
begin
  FEntity := AEntity;
  FDao := ADao;
end;

class function TController.New: IController;
begin
  Result := New(
    TEntity.Create
      .UsarCliente(
        function: ICliente
        begin
          Result := TCliente.New;
        end)
      .UsarProduto(
        function: IProduto
        begin
          Result := TProduto.New;
        end)
      .UsarPedido(
        function: IPedido
        begin
          Result := TPedido.New;
        end)
      .UsarPedidoItens(
        function: IItensPedido
        begin
          Result := TPedidoItens.New;
        end),
    function(AEntidade: IInterface; AConexao: IConnection): IDao
    begin
      Result := TDao.New(AEntidade, AConexao);
    end);
end;

class function TController.New(const AEntity: IEntity; const ADao: TFabricaDao): IController;
begin
  Result := Create(AEntity, ADao);
end;

function TController.Entity: IEntity;
begin
  Result := FEntity;
end;

function TController.Clientes: IClienteController;
begin
  Result := TClienteController.New(FEntity, FDao);
end;

function TController.Produtos: IProdutoController;
begin
  Result := TProdutoController.New(FEntity, FDao);
end;

function TController.Pedidos: IPedidoController;
begin
  Result := TPedidoController.New(FEntity, FDao);
end;

end.
