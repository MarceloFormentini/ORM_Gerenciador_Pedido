unit controller.produto.uProdutoController;

interface

uses
  controller.produto.uIProdutoController,
  controller.uIController,
  model.produto.uIProduto,
  model.entity.uIEntity,
  model.dao.uIDao;

type
  TProdutoController = class(TInterfacedObject, IProdutoController)
  private
    FEntity: IEntity;
    FDao: TFabricaDao;
    constructor Create(const AEntity: IEntity; const ADao: TFabricaDao);
    function Materializar(ADao: IDao): TArray<IProduto>;
  public
    class function New(const AEntity: IEntity; const ADao: TFabricaDao): IProdutoController;
    function Novo: IProduto;
    function Buscar(ACodigo: Integer): IProduto;
    function Listar: TArray<IProduto>;
    function PesquisarPorDescricao(const ADescricao: string): TArray<IProduto>;
    procedure Salvar(AProduto: IProduto);
    procedure Excluir(ACodigo: Integer);
  end;

implementation

uses
  Data.DB,
  model.validacao.uValidacao,
  utils.uMapeador;

constructor TProdutoController.Create(const AEntity: IEntity; const ADao: TFabricaDao);
begin
  FEntity := AEntity;
  FDao := ADao;
end;

class function TProdutoController.New(const AEntity: IEntity; const ADao: TFabricaDao): IProdutoController;
begin
  Result := Self.Create(AEntity, ADao);
end;

function TProdutoController.Novo: IProduto;
begin
  Result := FEntity.Produto;
end;

function TProdutoController.Buscar(ACodigo: Integer): IProduto;
var
  lDao: IDao;
begin
  Result := Novo.SetCodigo(ACodigo);
  lDao := FDao(Result, nil).ListarPorId;
  if lDao.Encontrou then
    lDao.Materializar;
end;

function TProdutoController.Materializar(ADao: IDao): TArray<IProduto>;
var
  lConsulta: TDataSet;
  lProduto: IProduto;
begin
  Result := nil;
  lConsulta := ADao.Consulta;
  if not Assigned(lConsulta) or lConsulta.IsEmpty then
    Exit;

  lConsulta.First;
  while not lConsulta.Eof do
  begin
    lProduto := Novo;
    TMapeador.Preencher(TObject(lProduto), lConsulta);
    Result := Result + [lProduto];
    lConsulta.Next;
  end;
end;

function TProdutoController.Listar: TArray<IProduto>;
begin
  Result := Materializar(FDao(Novo, nil).Listar);
end;

function TProdutoController.PesquisarPorDescricao(const ADescricao: string): TArray<IProduto>;
begin
  Result := Materializar(FDao(Novo.SetDescricao(ADescricao), nil).ListarContendo('DESCRICAO'));
end;

procedure TProdutoController.Salvar(AProduto: IProduto);
var
  lAtual: IProduto;
begin
  AProduto.Validar;
  if AProduto.GetCodigo <= 0 then
  begin
    FDao(AProduto, nil).Inserir;
    Exit;
  end;

  lAtual := Buscar(AProduto.GetCodigo);
  AProduto.SetEstoque(lAtual.GetEstoque);
  FDao(AProduto, nil).Atualizar;
end;

procedure TProdutoController.Excluir(ACodigo: Integer);
var
  lDao: IDao;
begin
  lDao := FDao(FEntity.PedidoItens.SetCodigoProduto(ACodigo), nil).ListarPor('CODIGO_PRODUTO');
  if lDao.Encontrou then
    raise EValidacao.Create(
      'CODIGO',
      'Produto vínculado a um pedido não pode ser excluído'
    );

  FDao(Novo.SetCodigo(ACodigo), nil).Excluir;
end;

end.
