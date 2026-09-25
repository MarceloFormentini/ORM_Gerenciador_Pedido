unit controller.pedido.uIPedidoController;

interface

uses
  model.pedido.uIPedido,
  model.pedidoItens.uIItensPedido,
  model.cliente.uICliente,
  model.produto.uIProduto;

type
  TItemPedidoConsulta = record
    Codigo: Integer;
    CodigoPedido: Integer;
    CodigoProduto: Integer;
    Descricao: string;
    Quantidade: Currency;
    ValorUnitario: Currency;
    ValorTotal: Currency;
  end;

  IPedidoController = interface
  ['{A1D94E27-6C38-4B70-8F15-2D9E4A7C6B01}']
    function Novo: IPedido;
    function NovoItem: IItensPedido;
    function BuscarPorNumero(const ANumero: string): IPedido;
    function BuscarCliente(ACodigo: Integer): ICliente;
    function BuscarProduto(ACodigo: Integer): IProduto;
    function ClienteRelacionado(APedido: IPedido): ICliente;
    function Itens(ACodigoPedido: Integer): TArray<TItemPedidoConsulta>;
    function Listar: TArray<IPedido>;
    function PesquisarPorNumero(const ANumero: string): TArray<IPedido>;
    procedure Salvar(APedido: IPedido);
    procedure Excluir(ACodigoPedido: Integer);
  end;

implementation

end.
