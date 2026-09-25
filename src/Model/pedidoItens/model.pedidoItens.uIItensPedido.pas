unit model.pedidoItens.uIItensPedido;

interface

type
  IItensPedido = interface
  ['{BDA69373-A07E-4695-A258-D1595E03C3B3}']
    function GetCodigo: Integer;
    function GetCodigoPedido: Integer;
    function GetCodigoProduto: Integer;
    function GetQuantidade: Currency;
    function GetValorUnitario: Currency;
    function GetValorTotal: Currency;

    function SetCodigo(const AValue: Integer): IItensPedido;
    function SetCodigoPedido(const AValue: Integer): IItensPedido;
    function SetCodigoProduto(const AValue: Integer): IItensPedido;
    function SetQuantidade(const AValue: Currency): IItensPedido;
    function SetValorUnitario(const AValue: Currency): IItensPedido;
    function SetValorTotal(const AValue: Currency): IItensPedido;

    function RecalcularTotal: Currency;
    procedure Validar;
  end;

implementation

end.
