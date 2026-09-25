unit model.produto.uIProduto;

interface

type
  IProduto = interface
  ['{98C6B183-C4DC-4172-B644-F4B9B4083ED9}']
    function GetCodigo: Integer;
    function GetDescricao: String;
    function GetPrecoVenda: Currency;
    function GetEstoque: Currency;

    function SetCodigo(const AValue: Integer): IProduto;
    function SetDescricao(const AValue: String): IProduto;
    function SetPrecoVenda(const AValue: Currency): IProduto;
    function SetEstoque(const AValue: Currency): IProduto;

    procedure Validar;
    procedure AplicarOperacao(const ATipo: string; AQuantidade: Currency; AEstorno: Boolean);
  end;

implementation

end.
