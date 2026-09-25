unit controller.uIController;

interface

uses
  model.entity.uIEntity,
  model.dao.uIDao,
  model.conexao.uIConnection,
  controller.cliente.uIClienteController,
  controller.produto.uIProdutoController,
  controller.pedido.uIPedidoController;

type
  TFabricaDao = reference to function(AEntidade: IInterface; AConexao: IConnection): IDao;

  IController = interface
  ['{C9E503D6-7F4A-4B8C-9D32-4A0E6F9C3B85}']
    function Entity: IEntity;
    function Clientes: IClienteController;
    function Produtos: IProdutoController;
    function Pedidos: IPedidoController;
  end;

implementation

end.
