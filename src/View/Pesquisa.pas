unit Pesquisa;

interface

uses
  controller.uIController,
  controller.cliente.uIClienteController,
  controller.produto.uIProdutoController,
  controller.pedido.uIPedidoController,
  model.cliente.uICliente,
  model.produto.uIProduto,
  model.pedido.uIPedido,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Data.DB,
  Vcl.Grids, Vcl.DBGrids, System.Generics.Collections, Datasnap.DBClient,
  utils.uEnum;

type
  TFPesquisa = class(TForm)
    PanelTop: TPanel;
    PanelGrid: TPanel;
    PanelBottom: TPanel;
    btnPesquisar: TButton;
    EditPesquisa: TEdit;
    lblPesquisaPor: TLabel;
    btnSelecionar: TButton;
    btnFechar: TButton;
    GridPesquisa: TDBGrid;
    lblPesquisa: TLabel;
    DataSourcePesquisa: TDataSource;
    procedure btnFecharClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSelecionarClick(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure GridPesquisaDblClick(Sender: TObject);

  private
    FController: IController;
    FClientes: IClienteController;
    FProdutos: IProdutoController;
    FPedidos: IPedidoController;
    FClientesLista: TArray<ICliente>;
    FProdutosLista: TArray<IProduto>;
    FPedidosLista: TArray<IPedido>;
    FDataSet: TClientDataSet;

    procedure PesquisaCliente;
    procedure PesquisaProduto;
    procedure PesquisaPedido;
    procedure PesquisaClientePor;
    procedure PesquisaProdutoPor;
    procedure PesquisaPedidoPor;
    procedure ConfigurarGridCliente;
    procedure ConfigurarGridProduto;
    procedure ConfigurarGridPedido;
    procedure PreencherClientes(const AClientes: TArray<ICliente>);
    procedure PreencherProdutos(const AProdutos: TArray<IProduto>);
    procedure PreencherPedidos(const APedidos: TArray<IPedido>);
  public
    TipoPesquisa: tTipoPesquisa;
    function ClienteSelecionado: ICliente;
    function ProdutoSelecionado: IProduto;
    function PedidoSelecionado: IPedido;
  end;

var
  FPesquisa: TFPesquisa;

implementation

{$R *.dfm}

uses
  controller.uController;

procedure TFPesquisa.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TFPesquisa.FormCreate(Sender: TObject);
begin
  FController := TController.New;
  FClientes := FController.Clientes;
  FProdutos := FController.Produtos;
  FPedidos := FController.Pedidos;
  FDataSet := TClientDataSet.Create(nil);
end;

procedure TFPesquisa.FormDestroy(Sender: TObject);
begin
  FDataSet.Free;
end;

procedure TFPesquisa.FormShow(Sender: TObject);
begin
  case TipoPesquisa of
    tpCliente:
      begin
        lblPesquisa.Caption := 'Pesquisa de Cliente';
        lblPesquisaPor.Caption := 'Pesquisar por Nome';
        PesquisaCliente;
      end;
    tpPedido:
      begin
        lblPesquisa.Caption := 'Pesquisa de Pedido';
        lblPesquisaPor.Caption := 'Pesquisar por Numero Pedido';
        PesquisaPedido;
      end;
    tpProduto:
      begin
        lblPesquisa.Caption := 'Pesquisa de Produto';
        lblPesquisaPor.Caption := 'Pesquisar por Descrição';
        PesquisaProduto;
      end;
  end;
  GridPesquisa.SetFocus;
end;

function TFPesquisa.ClienteSelecionado: ICliente;
begin
  Result := nil;
  if not Assigned(FDataSet) or FDataSet.IsEmpty then
    Exit;
  if (FDataSet.RecNo < 1) or (FDataSet.RecNo > Length(FClientesLista)) then
    Exit;

  Result := FClientesLista[FDataSet.RecNo - 1];
end;

function TFPesquisa.ProdutoSelecionado: IProduto;
begin
  Result := nil;
  if not Assigned(FDataSet) or FDataSet.IsEmpty then
    Exit;
  if (FDataSet.RecNo < 1) or (FDataSet.RecNo > Length(FProdutosLista)) then
    Exit;

  Result := FProdutosLista[FDataSet.RecNo - 1];
end;

function TFPesquisa.PedidoSelecionado: IPedido;
begin
  Result := nil;
  if not Assigned(FDataSet) or FDataSet.IsEmpty then
    Exit;
  if (FDataSet.RecNo < 1) or (FDataSet.RecNo > Length(FPedidosLista)) then
    Exit;

  Result := FPedidosLista[FDataSet.RecNo - 1];
end;

procedure TFPesquisa.GridPesquisaDblClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TFPesquisa.PesquisaCliente;
begin
  PreencherClientes(FClientes.Listar);
  ConfigurarGridCliente;
end;

procedure TFPesquisa.PesquisaClientePor;
begin
  PreencherClientes(FClientes.PesquisarPorNome(EditPesquisa.Text));
  ConfigurarGridCliente;
end;

procedure TFPesquisa.PesquisaPedido;
begin
  PreencherPedidos(FPedidos.Listar);
  ConfigurarGridPedido;
end;

procedure TFPesquisa.PesquisaPedidoPor;
begin
  if Trim(EditPesquisa.Text) = '' then
  begin
    ShowMessage('Informe o numero do pedido.');
    EditPesquisa.SetFocus;
    Exit;
  end;

  PreencherPedidos(FPedidos.PesquisarPorNumero(Trim(EditPesquisa.Text)));
  ConfigurarGridPedido;
end;

procedure TFPesquisa.PesquisaProduto;
begin
  PreencherProdutos(FProdutos.Listar);
  ConfigurarGridProduto;
end;

procedure TFPesquisa.PesquisaProdutoPor;
begin
  PreencherProdutos(FProdutos.PesquisarPorDescricao(EditPesquisa.Text));
  ConfigurarGridProduto;
end;

procedure TFPesquisa.btnPesquisarClick(Sender: TObject);
begin
  if EditPesquisa.Text = '' then
    Exit;

  case TipoPesquisa of
    tpCliente:
      PesquisaClientePor;
    tpPedido:
      PesquisaPedidoPor;
    tpProduto:
      PesquisaProdutoPor;
  end;
end;

procedure TFPesquisa.btnSelecionarClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TFPesquisa.ConfigurarGridCliente;
var
  Coluna: TColumn;
begin
  GridPesquisa.Columns.Clear; // Remove colunas existentes

  // Criando a coluna para o Código
  Coluna := GridPesquisa.Columns.Add;
  Coluna.Title.Caption := 'Código';
  Coluna.FieldName := 'CODIGO';
  Coluna.Width := 50;

  // Criando a coluna para o Nome
  Coluna := GridPesquisa.Columns.Add;
  Coluna.Title.Caption := 'Nome';
  Coluna.FieldName := 'NOME';
  // tamanho do grid menos o tamanho das outras colunas + mais bordas
  Coluna.Width := GridPesquisa.Width - 354;

  // Criando a coluna para o UF
  Coluna := GridPesquisa.Columns.Add;
  Coluna.Title.Caption := 'UF';
  Coluna.FieldName := 'UF';
  Coluna.Width := 50;

  // Criando a coluna para o Cidade
  Coluna := GridPesquisa.Columns.Add;
  Coluna.Title.Caption := 'Cidade';
  Coluna.FieldName := 'CIDADE';
  Coluna.Width := 230;

  DataSourcePesquisa.DataSet := FDataSet;
  DataSourcePesquisa.DataSet.Active := True;
  DataSourcePesquisa.DataSet.First;
  GridPesquisa.Refresh;
end;

procedure TFPesquisa.ConfigurarGridPedido;
var
  Coluna: TColumn;
begin
  GridPesquisa.Columns.Clear; // Remove colunas existentes

  // Criando a coluna para o Numero do Pedido
  Coluna := GridPesquisa.Columns.Add;
  Coluna.Title.Caption := 'Numero';
  Coluna.FieldName := 'NUMERO_PEDIDO';
  Coluna.Width := 70;

  // Criando a coluna para o Data Emissão
  Coluna := GridPesquisa.Columns.Add;
  Coluna.Title.Caption := 'Data Emissão';
  Coluna.FieldName := 'DATA_EMISSAO';
  Coluna.Width := 70;

  // Criando a coluna para o Referencia
  Coluna := GridPesquisa.Columns.Add;
  Coluna.Title.Caption := 'Referência';
  Coluna.FieldName := 'REFERENCIA';
  Coluna.Width := GridPesquisa.Width - 148;

  DataSourcePesquisa.DataSet := FDataSet;
  DataSourcePesquisa.DataSet.Active := True;
  DataSourcePesquisa.DataSet.First;
  GridPesquisa.Refresh;
end;

procedure TFPesquisa.ConfigurarGridProduto;
var
  Coluna: TColumn;
begin
  GridPesquisa.Columns.Clear; // Remove colunas existentes

  // Criando a coluna para o Código
  Coluna := GridPesquisa.Columns.Add;
  Coluna.Title.Caption := 'Código';
  Coluna.FieldName := 'CODIGO';
  Coluna.Width := 100;

  // Criando a coluna para o Nome
  Coluna := GridPesquisa.Columns.Add;
  Coluna.Title.Caption := 'Decrição';
  Coluna.FieldName := 'DESCRICAO';
  Coluna.Width := GridPesquisa.Width - 105;

  DataSourcePesquisa.DataSet := FDataSet;
  DataSourcePesquisa.DataSet.Active := True;
  DataSourcePesquisa.DataSet.First;
  GridPesquisa.Refresh;
end;

procedure TFPesquisa.PreencherClientes(const AClientes: TArray<ICliente>);
var
  lCliente: ICliente;
begin
  FClientesLista := AClientes;
  FProdutosLista := nil;
  FPedidosLista := nil;

  FDataSet.Close;
  FDataSet.FieldDefs.Clear;
  FDataSet.FieldDefs.Add('CODIGO', ftInteger);
  FDataSet.FieldDefs.Add('NOME', ftString, 100);
  FDataSet.FieldDefs.Add('UF', ftString, 2);
  FDataSet.FieldDefs.Add('CIDADE', ftString, 50);
  FDataSet.CreateDataSet;

  for lCliente in AClientes do
  begin
    FDataSet.Append;
    FDataSet.FieldByName('CODIGO').AsInteger := lCliente.GetCodigo;
    FDataSet.FieldByName('NOME').AsString := lCliente.GetNome;
    FDataSet.FieldByName('UF').AsString := lCliente.GetUF;
    FDataSet.FieldByName('CIDADE').AsString := lCliente.GetCidade;
    FDataSet.Post;
  end;
end;

procedure TFPesquisa.PreencherProdutos(const AProdutos: TArray<IProduto>);
var
  lProduto: IProduto;
begin
  FProdutosLista := AProdutos;
  FClientesLista := nil;
  FPedidosLista := nil;

  FDataSet.Close;
  FDataSet.FieldDefs.Clear;
  FDataSet.FieldDefs.Add('CODIGO', ftInteger);
  FDataSet.FieldDefs.Add('DESCRICAO', ftString, 100);
  FDataSet.CreateDataSet;

  for lProduto in AProdutos do
  begin
    FDataSet.Append;
    FDataSet.FieldByName('CODIGO').AsInteger := lProduto.GetCodigo;
    FDataSet.FieldByName('DESCRICAO').AsString := lProduto.GetDescricao;
    FDataSet.Post;
  end;
end;

procedure TFPesquisa.PreencherPedidos(const APedidos: TArray<IPedido>);
var
  lPedido: IPedido;
begin
  FPedidosLista := APedidos;
  FClientesLista := nil;
  FProdutosLista := nil;

  FDataSet.Close;
  FDataSet.FieldDefs.Clear;
  FDataSet.FieldDefs.Add('NUMERO_PEDIDO', ftString, 20);
  FDataSet.FieldDefs.Add('DATA_EMISSAO', ftDateTime);
  FDataSet.FieldDefs.Add('REFERENCIA', ftString, 50);
  FDataSet.CreateDataSet;

  for lPedido in APedidos do
  begin
    FDataSet.Append;
    FDataSet.FieldByName('NUMERO_PEDIDO').AsString := lPedido.GetNumeroPedido;
    FDataSet.FieldByName('DATA_EMISSAO').AsDateTime := lPedido.GetDataEmissao;
    FDataSet.FieldByName('REFERENCIA').AsString := lPedido.GetReferencia;
    FDataSet.Post;
  end;
end;

end.
