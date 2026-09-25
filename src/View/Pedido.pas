unit Pedido;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  System.ImageList, Vcl.ImgList, Vcl.Mask, Vcl.DBCtrls,
  controller.uIController, controller.pedido.uIPedidoController, Data.DB, model.validacao.uValidacao,
  Vcl.Grids, Vcl.DBGrids, Datasnap.DBClient,
  model.totalizador.uITotalizadorValor, utils.uEnum,
  model.pedido.uIPedido, model.cliente.uICliente, model.produto.uIProduto,
  model.pedidoItens.uIItensPedido;

type
  TFPedido = class(TForm)
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    PanelPedido: TPanel;
    Panel2: TPanel;
    btnFechar: TButton;
    btnAvancar: TButton;
    Panel3: TPanel;
    Panel4: TPanel;
    btnVoltar: TButton;
    btnSalvar: TButton;
    Label1: TLabel;
    btnPesquisa: TButton;
    Shape: TShape;
    Label5: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    DataEmissao: TDateTimePicker;
    RadioGroup1: TRadioGroup;
    EditNumeroPedido: TEdit;
    ImageList: TImageList;
    EditReferencia: TEdit;
    EditCodigoCliente: TEdit;
    EditNomeCliente: TEdit;
    btnPesquisaCliente: TButton;
    btnNovo: TButton;
    Panel5: TPanel;
    Label7: TLabel;
    EditTotalPedido: TEdit;
    Label8: TLabel;
    btnPesquisaProduto: TButton;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    btnInserirItem: TButton;
    btnRemoverItem: TButton;
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    GridItensPedido: TDBGrid;
    ClientDataSetCODIGO: TIntegerField;
    ClientDataSetDESCRICAO: TStringField;
    ClientDataSetQUANTIDADE: TFloatField;
    ClientDataSetVALOR_UNITARIO: TFloatField;
    ClientDataSetTOTAL_ITEM: TFloatField;
    VALOR_UNITARIO: TDBEdit;
    ClientDataSetCODIGO_PEDIDO: TIntegerField;
    ClientDataSetCODIGO_PRODUTO: TIntegerField;
    TOTAL_ITEM: TDBEdit;
    QUANTIDADE: TDBEdit;
    CODIGO_PRODUTO: TDBEdit;
    DESCRICAO: TDBEdit;
    btnNovoItem: TButton;
    btnCancelarItem: TButton;
    btnExcluir: TButton;
    procedure btnFecharClick(Sender: TObject);
    procedure btnAvancarClick(Sender: TObject);
    procedure btnVoltarClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EditNumeroPedidoKeyPress(Sender: TObject; var Key: Char);
    procedure btnPesquisaClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnPesquisaClienteClick(Sender: TObject);
    procedure btnNovoItemClick(Sender: TObject);
    procedure btnInserirItemClick(Sender: TObject);
    procedure EditCodigoClienteKeyPress(Sender: TObject; var Key: Char);
    procedure btnCancelarItemClick(Sender: TObject);
    procedure btnPesquisaProdutoClick(Sender: TObject);
    procedure ClientDataSetAfterEdit(DataSet: TDataSet);
    procedure ClientDataSetVALOR_UNITARIOChange(Sender: TField);
    procedure ClientDataSetQUANTIDADEChange(Sender: TField);
    procedure CODIGO_PRODUTOKeyPress(Sender: TObject; var Key: Char);
    procedure btnRemoverItemClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
  private
    FController: IController;
    FPedidos: IPedidoController;
    FCodigoPedido: Integer;
    FTotalizadorValor: ITotalizadorValor;
    FItensCarregados: Boolean;

    procedure LimparCampos;
    procedure ReiniciarItens;

    procedure CarregarDados(APedido: IPedido);
    procedure CarregarDadosCliente(ACliente: ICliente);
    procedure PesquisarCliente(ACliente: Integer);

    procedure CarregarDadosProduto(AProduto: IProduto);
    procedure PesquisarProduto(AProduto: Integer);

    procedure AbrirPesquisa(ATipoPesquisa: tTipoPesquisa);
    procedure PesquisaItensPedido;
    procedure CarregaItensPedido(const AItens: TArray<TItemPedidoConsulta>);

    procedure CalcularTotalItem;
    procedure MostrarValidacao(E: EValidacao);
    function MontarCabecalho: IPedido;
    function MontarPedido: IPedido;
  end;

var
  FPedido: TFPedido;

implementation

uses
  controller.uController, Pesquisa, model.totalizador.uTotalizadorValor;

{$R *.dfm}

procedure TFPedido.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TFPedido.btnInserirItemClick(Sender: TObject);
var
  lItem: IItensPedido;
begin
  lItem := FPedidos.NovoItem
    .SetCodigoProduto(ClientDataSetCODIGO_PRODUTO.AsInteger)
    .SetQuantidade(ClientDataSetQUANTIDADE.AsFloat)
    .SetValorUnitario(ClientDataSetVALOR_UNITARIO.AsFloat);
  try
    lItem.Validar;
  except
    on E: EValidacao do
    begin
      MostrarValidacao(E);
      Exit;
    end;
  end;

  ClientDataSetTOTAL_ITEM.AsFloat := lItem.GetValorTotal;
  ClientDataSet.Post;
  btnInserirItem.Enabled := False;
  btnCancelarItem.Enabled := False;
  btnNovoItem.Enabled := True;
  btnRemoverItem.Enabled := True;
  EditTotalPedido.Text := FTotalizadorValor.CalcularTotal;
end;

procedure TFPedido.btnNovoClick(Sender: TObject);
begin
  LimparCampos;
  btnExcluir.Enabled := False;
  EditNumeroPedido.SetFocus;
end;

procedure TFPedido.btnNovoItemClick(Sender: TObject);
begin
  ClientDataSet.Append;
  CODIGO_PRODUTO.SetFocus;
  btnNovoItem.Enabled := False;
  btnRemoverItem.Enabled := False;
  btnCancelarItem.Enabled := True;
  btnInserirItem.Enabled := True;
end;

procedure TFPedido.btnPesquisaClick(Sender: TObject);
begin
  AbrirPesquisa(tpPedido);
end;

procedure TFPedido.btnPesquisaClienteClick(Sender: TObject);
begin
  AbrirPesquisa(tpCliente);
end;

procedure TFPedido.btnPesquisaProdutoClick(Sender: TObject);
var
  FPesquisa : TFPesquisa;
begin
  FPesquisa := TFPesquisa.Create(Self);
  FPesquisa.TipoPesquisa := tpProduto;
  try
      if FPesquisa.ShowModal = mrOk then
      CarregarDadosProduto(FPesquisa.ProdutoSelecionado);
  finally
    FPesquisa.Free;
  end;
end;

procedure TFPedido.btnRemoverItemClick(Sender: TObject);
begin
  if ClientDataSet.IsEmpty then
    Exit;

  ClientDataSet.Delete;
  EditTotalPedido.Text := FTotalizadorValor.CalcularTotal;
end;

function TFPedido.MontarCabecalho: IPedido;
var
  lTipo: string;
begin
  if RadioGroup1.ItemIndex = 0 then
    lTipo := 'E'
  else
    lTipo := 'S';

  Result := FPedidos.Novo
    .SetCodigo(FCodigoPedido)
    .SetReferencia(EditReferencia.Text)
    .SetNumeroPedido(Trim(EditNumeroPedido.Text))
    .SetDataEmissao(DataEmissao.DateTime)
    .SetCodigoCliente(StrToIntDef(EditCodigoCliente.Text, 0))
    .SetTipoPedido(lTipo);
end;

function TFPedido.MontarPedido: IPedido;
begin
  Result := MontarCabecalho;
  ClientDataSet.DisableControls;
  try
    ClientDataSet.First;
    while not ClientDataSet.Eof do
    begin
      Result.AdicionarItem(
        FPedidos.NovoItem
          .SetCodigo(ClientDataSetCODIGO.AsInteger)
          .SetCodigoProduto(ClientDataSetCODIGO_PRODUTO.AsInteger)
          .SetQuantidade(ClientDataSetQUANTIDADE.AsFloat)
          .SetValorUnitario(ClientDataSetVALOR_UNITARIO.AsFloat)
          .SetValorTotal(ClientDataSetTOTAL_ITEM.AsFloat)
      );
      ClientDataSet.Next;
    end;
  finally
    ClientDataSet.EnableControls;
  end;
end;

procedure TFPedido.MostrarValidacao(E: EValidacao);
begin
  ShowMessage(E.Message);
  if E.Campo = 'NUMERO_PEDIDO' then
    EditNumeroPedido.SetFocus
  else if E.Campo = 'REFERENCIA' then
    EditReferencia.SetFocus
  else if E.Campo = 'DATA_EMISSAO' then
    DataEmissao.SetFocus
  else if E.Campo = 'CODIGO_CLIENTE' then
    EditCodigoCliente.SetFocus
  else if E.Campo = 'CODIGO_PRODUTO' then
    CODIGO_PRODUTO.SetFocus
  else if E.Campo = 'QUANTIDADE' then
    QUANTIDADE.SetFocus
  else if E.Campo = 'VALOR_UNITARIO' then
    VALOR_UNITARIO.SetFocus;
end;

procedure TFPedido.btnSalvarClick(Sender: TObject);
var
  lPedido: IPedido;
begin
  lPedido := MontarPedido;
  try
    lPedido.Validar;
  except
    on E: EValidacao do
    begin
      MostrarValidacao(E);
      Exit;
    end;
  end;

  if MessageDlg('Confirma o pedido?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    Exit;

  try
    FPedidos.Salvar(lPedido);
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao salvar pedido. ' + E.Message);
      Exit;
    end;
  end;

  ShowMessage('Pedido gravado com sucesso.');
  btnVoltar.Click;
  btnNovo.Click;
end;

procedure TFPedido.btnVoltarClick(Sender: TObject);
begin
  PageControl.SelectNextPage(False, False);
end;

procedure TFPedido.PesquisaItensPedido;
begin
  if FCodigoPedido <= 0 then
    Exit;

  ReiniciarItens;
  CarregaItensPedido(FPedidos.Itens(FCodigoPedido));
end;

procedure TFPedido.PesquisarCliente(ACliente: Integer);
begin
  CarregarDadosCliente(FPedidos.BuscarCliente(ACliente));
end;

procedure TFPedido.PesquisarProduto(AProduto: Integer);
begin
  CarregarDadosProduto(FPedidos.BuscarProduto(AProduto));
end;

procedure TFPedido.CalcularTotalItem;
begin
  ClientDataSetTOTAL_ITEM.AsFloat := FPedidos.NovoItem
    .SetQuantidade(ClientDataSetQUANTIDADE.AsFloat)
    .SetValorUnitario(ClientDataSetVALOR_UNITARIO.AsFloat)
    .RecalcularTotal;
end;

procedure TFPedido.CarregaItensPedido(const AItens: TArray<TItemPedidoConsulta>);
var
  lItem: TItemPedidoConsulta;
begin
  if Length(AItens) = 0 then
  begin
    ClientDataSet.Append;
    Exit;
  end;

  for lItem in AItens do
  begin
    ClientDataSet.Append;
    ClientDataSetCODIGO.AsInteger := lItem.Codigo;
    ClientDataSetCODIGO_PEDIDO.AsInteger := lItem.CodigoPedido;
    ClientDataSetCODIGO_PRODUTO.AsInteger := lItem.CodigoProduto;
    ClientDataSetQUANTIDADE.AsFloat := lItem.Quantidade;
    ClientDataSetVALOR_UNITARIO.AsFloat := lItem.ValorUnitario;
    ClientDataSetTOTAL_ITEM.AsFloat := lItem.ValorTotal;
    ClientDataSetDESCRICAO.AsString := lItem.Descricao;
    ClientDataSet.Post;
  end;
  ClientDataSet.First;
end;

procedure TFPedido.CarregarDados(APedido: IPedido);
var
  lNumeroDigitado: string;
begin
  lNumeroDigitado := Trim(EditNumeroPedido.Text);
  LimparCampos;
  EditNumeroPedido.Text := lNumeroDigitado;
  btnExcluir.Enabled := False;

  if not Assigned(APedido) or (APedido.GetCodigo <= 0) then
    Exit;

  FCodigoPedido := APedido.GetCodigo;
  EditNumeroPedido.Text := APedido.GetNumeroPedido;
  EditReferencia.Text := APedido.GetReferencia;
  DataEmissao.DateTime := APedido.GetDataEmissao;

  if APedido.GetTipoPedido = 'E' then
    RadioGroup1.ItemIndex := 0
  else
    RadioGroup1.ItemIndex := 1;

  CarregarDadosCliente(FPedidos.ClienteRelacionado(APedido));
  btnExcluir.Enabled := True;
end;

procedure TFPedido.CarregarDadosCliente(ACliente: ICliente);
begin
  EditCodigoCliente.Clear;
  EditNomeCliente.Clear;

  if not Assigned(ACliente) or (ACliente.GetCodigo <= 0) then
    Exit;

  EditCodigoCliente.Text := ACliente.GetCodigo.ToString;
  EditNomeCliente.Text := ACliente.GetNome;
end;

procedure TFPedido.CarregarDadosProduto(AProduto: IProduto);
begin
  ClientDataSetDESCRICAO.Clear;
  ClientDataSetCODIGO_PRODUTO.Clear;

  if not Assigned(AProduto) or (AProduto.GetCodigo <= 0) then
    Exit;

  ClientDataSetDESCRICAO.AsString := AProduto.GetDescricao;
  ClientDataSetCODIGO_PRODUTO.AsInteger := AProduto.GetCodigo;
  ClientDataSetVALOR_UNITARIO.AsCurrency := AProduto.GetPrecoVenda;
end;

procedure TFPedido.ClientDataSetAfterEdit(DataSet: TDataSet);
begin
  btnNovoItem.Enabled := False;
  btnInserirItem.Enabled := True;
  btnCancelarItem.Enabled := True;
  btnRemoverItem.Enabled := False;
end;

procedure TFPedido.ClientDataSetQUANTIDADEChange(Sender: TField);
begin
  CalcularTotalItem;
end;

procedure TFPedido.ClientDataSetVALOR_UNITARIOChange(Sender: TField);
begin
  CalcularTotalItem;
end;

procedure TFPedido.CODIGO_PRODUTOKeyPress(Sender: TObject; var Key: Char);
var
  lCodigo: Integer;
begin
  if Key <> #13 then
    Exit;

  Key := #0;
  if not TryStrToInt(Trim(CODIGO_PRODUTO.Text), lCodigo) then
  begin
    ShowMessage('Informe um código de produto numérico.');
    Exit;
  end;

  PesquisarProduto(lCodigo);
  Perform(Wm_NextDlgCtl, 0, 0);
end;

procedure TFPedido.EditCodigoClienteKeyPress(Sender: TObject; var Key: Char);
begin
  if Key <> #13 then
    Exit;

  if EditCodigoCliente.Text = '' then
    Exit;

  PesquisarCliente(StrToInt(EditCodigoCliente.Text));
end;

procedure TFPedido.EditNumeroPedidoKeyPress(Sender: TObject; var Key: Char);
begin
  if Key <> #13 then
    Exit;

  CarregarDados(FPedidos.BuscarPorNumero(EditNumeroPedido.Text));
end;

procedure TFPedido.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to PageControl.PageCount -1 do
    PageControl.Pages[i].TabVisible := False;

  PageControl.ActivePage := PageControl.Pages[0];

  FController := TController.New;
  FPedidos := FController.Pedidos;
  FTotalizadorValor := TTotalizadorValor.New(ClientDataSet);
  LimparCampos;
  Shape.Width := PanelPedido.Width - 2;
end;

procedure TFPedido.FormShow(Sender: TObject);
begin
  EditNumeroPedido.SetFocus;
  btnExcluir.Enabled := False;
end;

procedure TFPedido.ReiniciarItens;
begin
  ClientDataSet.Close;
  ClientDataSet.CreateDataSet;
  ClientDataSet.Open;
end;

procedure TFPedido.LimparCampos;
begin
  EditNumeroPedido.Clear;
  EditReferencia.Clear;
  DataEmissao.DateTime := Now();
  EditCodigoCliente.Clear;
  EditNomeCliente.Clear;
  RadioGroup1.ItemIndex := 1;
  FCodigoPedido := 0;
  FItensCarregados := False;
  ReiniciarItens;
end;

procedure TFPedido.AbrirPesquisa(ATipoPesquisa: tTipoPesquisa);
var
  FPesquisa: TFPesquisa;
begin
  FPesquisa := TFPesquisa.Create(Self);
  FPesquisa.TipoPesquisa := ATipoPesquisa;
  try
    if FPesquisa.ShowModal = mrOk then
    begin
      case ATipoPesquisa of
        tpCliente:
          CarregarDadosCliente(FPesquisa.ClienteSelecionado);
        tpPedido:
          CarregarDados(FPesquisa.PedidoSelecionado);
      end;
    end;
  finally
    FPesquisa.Free;
  end;
end;

procedure TFPedido.btnAvancarClick(Sender: TObject);
begin
  try
    MontarCabecalho.ValidarCabecalho;
  except
    on E: EValidacao do
    begin
      MostrarValidacao(E);
      Exit;
    end;
  end;

  if not FItensCarregados then
  begin
    PesquisaItensPedido;
    FItensCarregados := True;
  end;

  PageControl.SelectNextPage(True, False);
  if ClientDataSet.IsEmpty then
    btnNovoItem.Click
  else
  begin
    btnInserirItem.Enabled := False;
    btnCancelarItem.Enabled := False;
  end;
  EditTotalPedido.Text := FTotalizadorValor.CalcularTotal;

  CODIGO_PRODUTO.SetFocus;
end;

procedure TFPedido.btnCancelarItemClick(Sender: TObject);
begin
  ClientDataSet.Cancel;
  btnCancelarItem.Enabled := False;
  btnInserirItem.Enabled := False;
  btnNovoItem.Enabled := True;
  btnRemoverItem.Enabled := True;
end;

procedure TFPedido.btnExcluirClick(Sender: TObject);
begin
  if MessageDlg('Confirma a exclusão do pedido?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    Exit;

  try
    FPedidos.Excluir(FCodigoPedido);
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao excluir pedido. ' + E.Message);
      Exit;
    end;
  end;

  btnVoltar.Click;
  btnNovo.Click;
end;

end.
