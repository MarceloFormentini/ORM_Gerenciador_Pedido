unit controller.produto.uIProdutoController;

interface

uses
  model.produto.uIProduto;

type
  IProdutoController = interface
  ['{3E8A6C14-2B70-4D55-9F21-8A4C7E1D5B36}']
    function Novo: IProduto;
    function Buscar(ACodigo: Integer): IProduto;
    function Listar: TArray<IProduto>;
    function PesquisarPorDescricao(const ADescricao: string): TArray<IProduto>;
    procedure Salvar(AProduto: IProduto);
    procedure Excluir(ACodigo: Integer);
  end;

implementation

end.
