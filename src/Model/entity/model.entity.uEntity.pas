unit model.entity.uEntity;

interface

uses
  model.entity.uIEntity,
  model.cliente.uICliente,
  model.produto.uIProduto,
  model.pedido.uIPedido,
  model.pedidoItens.uIItensPedido;

type
  TFabricaCliente = reference to function: ICliente;
  TFabricaProduto = reference to function: IProduto;
  TFabricaPedido = reference to function: IPedido;
  TFabricaPedidoItens = reference to function: IItensPedido;

  TEntity = class(TInterfacedObject, IEntity)
  private
    FCriarCliente: TFabricaCliente;
    FCriarProduto: TFabricaProduto;
    FCriarPedido: TFabricaPedido;
    FCriarPedidoItens: TFabricaPedidoItens;

  public
    constructor Create;
    class function New: IEntity;

    function UsarCliente(AFabrica: TFabricaCliente): TEntity;
    function UsarProduto(AFabrica: TFabricaProduto): TEntity;
    function UsarPedido(AFabrica: TFabricaPedido): TEntity;
    function UsarPedidoItens(AFabrica: TFabricaPedidoItens): TEntity;

    function Cliente: ICliente;
    function Produto: IProduto;
    function Pedido: IPedido;
    function PedidoItens: IItensPedido;
  end;

implementation

uses
  model.cliente.uCliente, model.pedido.uPedido,
  model.pedidoItens.uItensPedido, model.produto.uProduto;

constructor TEntity.Create;
begin
  FCriarCliente := function: ICliente
    begin
      Result := TCliente.New;
    end;
  FCriarProduto := function: IProduto
    begin
      Result := TProduto.New;
    end;
  FCriarPedido := function: IPedido
    begin
      Result := TPedido.New;
    end;
  FCriarPedidoItens := function: IItensPedido
    begin
      Result := TPedidoItens.New;
    end;
end;

class function TEntity.New: IEntity;
begin
  Result := Self.Create;
end;

function TEntity.UsarCliente(AFabrica: TFabricaCliente): TEntity;
begin
  FCriarCliente := AFabrica;
  Result := Self;
end;

function TEntity.UsarProduto(AFabrica: TFabricaProduto): TEntity;
begin
  FCriarProduto := AFabrica;
  Result := Self;
end;

function TEntity.UsarPedido(AFabrica: TFabricaPedido): TEntity;
begin
  FCriarPedido := AFabrica;
  Result := Self;
end;

function TEntity.UsarPedidoItens(AFabrica: TFabricaPedidoItens): TEntity;
begin
  FCriarPedidoItens := AFabrica;
  Result := Self;
end;

function TEntity.Cliente: ICliente;
begin
  Result := FCriarCliente();
end;

function TEntity.Pedido: IPedido;
begin
  Result := FCriarPedido();
end;

function TEntity.PedidoItens: IItensPedido;
begin
  Result := FCriarPedidoItens();
end;

function TEntity.Produto: IProduto;
begin
  Result := FCriarProduto();
end;

end.
