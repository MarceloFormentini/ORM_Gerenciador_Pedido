unit controller.pedido.uPedidoController;

interface

uses
  controller.pedido.uIPedidoController,
  controller.uIController,
  model.pedido.uIPedido,
  model.pedidoItens.uIItensPedido,
  model.cliente.uICliente,
  model.produto.uIProduto,
  model.entity.uIEntity,
  model.dao.uIDao,
  model.conexao.uIConnection,
  Data.DB;

type
  TPedidoController = class(TInterfacedObject, IPedidoController)
  private
    FEntity: IEntity;
    FDao: TFabricaDao;

    function Materializar(ADao: IDao): TArray<IPedido>;
    procedure AplicarEstoque(AConexao: IConnection; const ATipo: string;
      ACodigoProduto: Integer; AQuantidade: Currency; AEstorno: Boolean);
    procedure EstornarItensGravados(AConexao: IConnection; ACodigoPedido: Integer);
    procedure ExcluirItensAusentes(AConexao: IConnection; APedido: IPedido);
    constructor Create(const AEntity: IEntity; const ADao: TFabricaDao);
  public
    class function New(const AEntity: IEntity; const ADao: TFabricaDao): IPedidoController;
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

uses
  System.SysUtils,
  System.Generics.Collections,
  model.conexao.uConnectionFiredac,
  utils.uMapeador;

constructor TPedidoController.Create(const AEntity: IEntity; const ADao: TFabricaDao);
begin
  FEntity := AEntity;
  FDao := ADao;
end;

class function TPedidoController.New(const AEntity: IEntity; const ADao: TFabricaDao): IPedidoController;
begin
  Result := Self.Create(AEntity, ADao);
end;

function TPedidoController.Novo: IPedido;
begin
  Result := FEntity.Pedido;
end;

function TPedidoController.NovoItem: IItensPedido;
begin
  Result := FEntity.PedidoItens;
end;

function TPedidoController.BuscarPorNumero(const ANumero: string): IPedido;
var
  lDao: IDao;
begin
  Result := Novo.SetNumeroPedido(Trim(ANumero));
  lDao := FDao(Result, nil).ListarPor('NUMERO_PEDIDO');
  if lDao.Encontrou then
    lDao.Materializar;
end;

function TPedidoController.BuscarCliente(ACodigo: Integer): ICliente;
var
  lDao: IDao;
begin
  Result := FEntity.Cliente.SetCodigo(ACodigo);
  lDao := FDao(Result, nil).ListarPorId;
  if lDao.Encontrou then
    lDao.Materializar;
end;

function TPedidoController.BuscarProduto(ACodigo: Integer): IProduto;
var
  lDao: IDao;
begin
  Result := FEntity.Produto.SetCodigo(ACodigo);
  lDao := FDao(Result, nil).ListarPorId;
  if lDao.Encontrou then
    lDao.Materializar;
end;

function TPedidoController.ClienteRelacionado(APedido: IPedido): ICliente;
begin
  Result := FDao(APedido, nil).Relacionado('CODIGO_CLIENTE') as ICliente;
end;

function TPedidoController.Itens(ACodigoPedido: Integer): TArray<TItemPedidoConsulta>;
var
  lDao: IDao;
  lConsulta: TDataSet;
  lItem: IItensPedido;
  lProduto: IProduto;
  lLinha: TItemPedidoConsulta;
begin
  Result := nil;
  if ACodigoPedido <= 0 then
    Exit;

  lDao := FDao(NovoItem.SetCodigoPedido(ACodigoPedido), nil).ListarPor('CODIGO_PEDIDO');
  lConsulta := lDao.Consulta;
  if not Assigned(lConsulta) or lConsulta.IsEmpty then
    Exit;

  lConsulta.First;
  while not lConsulta.Eof do
  begin
    lItem := NovoItem;
    TMapeador.Preencher(TObject(lItem), lConsulta);

    lLinha.Codigo := lItem.GetCodigo;
    lLinha.CodigoPedido := lItem.GetCodigoPedido;
    lLinha.CodigoProduto := lItem.GetCodigoProduto;
    lLinha.Quantidade := lItem.GetQuantidade;
    lLinha.ValorUnitario := lItem.GetValorUnitario;
    lLinha.ValorTotal := lItem.GetValorTotal;
    lLinha.Descricao := '';

    lProduto := FDao(lItem, nil).Relacionado('CODIGO_PRODUTO') as IProduto;
    if Assigned(lProduto) then
      lLinha.Descricao := lProduto.GetDescricao;

    Result := Result + [lLinha];
    lConsulta.Next;
  end;
end;

function TPedidoController.Materializar(ADao: IDao): TArray<IPedido>;
var
  lConsulta: TDataSet;
  lPedido: IPedido;
begin
  Result := nil;
  lConsulta := ADao.Consulta;
  if not Assigned(lConsulta) or lConsulta.IsEmpty then
    Exit;

  lConsulta.First;
  while not lConsulta.Eof do
  begin
    lPedido := Novo;
    TMapeador.Preencher(TObject(lPedido), lConsulta);
    Result := Result + [lPedido];
    lConsulta.Next;
  end;
end;

function TPedidoController.Listar: TArray<IPedido>;
begin
  Result := Materializar(FDao(Novo, nil).Listar);
end;

function TPedidoController.PesquisarPorNumero(const ANumero: string): TArray<IPedido>;
begin
  Result := Materializar(
    FDao(Novo.SetNumeroPedido(Trim(ANumero)), nil).ListarContendo('NUMERO_PEDIDO')
  );
end;

procedure TPedidoController.AplicarEstoque(AConexao: IConnection; const ATipo: string;
  ACodigoProduto: Integer; AQuantidade: Currency; AEstorno: Boolean);
var
  lProduto: IProduto;
  lDao: IDao;
begin
  if ACodigoProduto <= 0 then
    Exit;

  lProduto := FEntity.Produto.SetCodigo(ACodigoProduto);
  lDao := FDao(lProduto, AConexao).ListarPorId;
  if not lDao.Encontrou then
    raise Exception.Create('Produto não encontrado para movimentar o estoque.');

  lDao.Materializar;
  lProduto.AplicarOperacao(ATipo, AQuantidade, AEstorno);
  FDao(lProduto, AConexao).Atualizar;
end;

procedure TPedidoController.EstornarItensGravados(AConexao: IConnection; ACodigoPedido: Integer);
var
  lPedido: IPedido;
  lDao: IDao;
  lItens: TDataSet;
begin
  lPedido := Novo.SetCodigo(ACodigoPedido);
  lDao := FDao(lPedido, AConexao).ListarPorId;
  if not lDao.Encontrou then
    Exit;

  lDao.Materializar;

  lDao := FDao(NovoItem.SetCodigoPedido(ACodigoPedido), AConexao).ListarPor('CODIGO_PEDIDO');
  lItens := lDao.Consulta;
  if not Assigned(lItens) or lItens.IsEmpty then
    Exit;

  lItens.First;
  while not lItens.Eof do
  begin
    AplicarEstoque(
      AConexao,
      lPedido.GetTipoPedido,
      lItens.FieldByName('CODIGO_PRODUTO').AsInteger,
      lItens.FieldByName('QUANTIDADE').AsCurrency,
      True
    );
    lItens.Next;
  end;
end;

procedure TPedidoController.ExcluirItensAusentes(AConexao: IConnection; APedido: IPedido);
var
  lDao: IDao;
  lItens: TDataSet;
  lCodigo: Integer;
  lItem: IItensPedido;
  lMantem: Boolean;
begin
  lDao := FDao(NovoItem.SetCodigoPedido(APedido.GetCodigo), AConexao).ListarPor('CODIGO_PEDIDO');
  lItens := lDao.Consulta;
  if not Assigned(lItens) or lItens.IsEmpty then
    Exit;

  lItens.First;
  while not lItens.Eof do
  begin
    lCodigo := lItens.FieldByName('CODIGO').AsInteger;
    lMantem := False;
    for lItem in APedido.Itens do
      if lItem.GetCodigo = lCodigo then
        lMantem := True;

    if not lMantem then
      FDao(
        NovoItem.SetCodigo(lCodigo).SetCodigoPedido(APedido.GetCodigo),
        AConexao
      ).Excluir;

    lItens.Next;
  end;
end;

procedure TPedidoController.Salvar(APedido: IPedido);
var
  lConexao: IConnection;
  lItem: IItensPedido;
begin
  APedido.Validar;

  lConexao := TConnectionFiredac.New;
  lConexao.IniciarTransacao;
  try
    if APedido.GetCodigo > 0 then
    begin
      EstornarItensGravados(lConexao, APedido.GetCodigo);
      FDao(APedido, lConexao).Atualizar;
      ExcluirItensAusentes(lConexao, APedido);
    end
    else
      FDao(APedido, lConexao).Inserir;

    for lItem in APedido.Itens do
    begin
      lItem.SetCodigoPedido(APedido.GetCodigo);
      if lItem.GetCodigo > 0 then
        FDao(lItem, lConexao).Atualizar
      else
        FDao(lItem, lConexao).Inserir;

      AplicarEstoque(
        lConexao,
        APedido.GetTipoPedido,
        lItem.GetCodigoProduto,
        lItem.GetQuantidade,
        False
      );
    end;

    lConexao.ConfirmarTransacao;
  except
    lConexao.CancelarTransacao;
    raise;
  end;
end;

procedure TPedidoController.Excluir(ACodigoPedido: Integer);
var
  lConexao: IConnection;
begin
  lConexao := TConnectionFiredac.New;
  lConexao.IniciarTransacao;
  try
    EstornarItensGravados(lConexao, ACodigoPedido);
    FDao(NovoItem.SetCodigoPedido(ACodigoPedido), lConexao).ExcluirPor('CODIGO_PEDIDO');
    FDao(Novo.SetCodigo(ACodigoPedido), lConexao).Excluir;
    lConexao.ConfirmarTransacao;
  except
    lConexao.CancelarTransacao;
    raise;
  end;
end;

end.
