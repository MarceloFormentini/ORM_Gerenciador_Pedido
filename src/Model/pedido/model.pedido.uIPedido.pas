unit model.pedido.uIPedido;

interface

uses
  System.Generics.Collections,
  model.pedidoItens.uIItensPedido;

type
  IPedido = interface
  ['{824013C1-04B1-4E12-A271-217C563509CC}']
    function GetCodigo: Integer;
    function GetReferencia: String;
    function GetNumeroPedido: String;
    function GetDataEmissao: TDateTime;
    function GetCodigoCliente: Integer;
    function GetTipoPedido: String;
    function GetValorTotal: Currency;

    function SetCodigo(const AValue: Integer): IPedido;
    function SetReferencia(const AValue: String): IPedido;
    function SetNumeroPedido(const AValue: String): IPedido;
    function SetDataEmissao(AValue: TDateTime): IPedido;
    function SetCodigoCliente(const AValue: Integer): IPedido;
    function SetTipoPedido(const AValue: String): IPedido;
    function SetValorTotal(const AValue: Currency): IPedido;

    function Itens: TList<IItensPedido>;
    function AdicionarItem(AItem: IItensPedido): IPedido;
    procedure ValidarCabecalho;
    procedure Validar;
  end;

implementation

end.
