unit Produto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.ImageList, Vcl.ImgList,
  Vcl.StdCtrls, Vcl.ExtCtrls,
  controller.uIController, controller.produto.uIProdutoController, Vcl.Mask,
  model.produto.uIProduto, model.validacao.uValidacao;

type
  TFProduto = class(TForm)
    PanelBottom: TPanel;
    btnExcluir: TButton;
    btnSalvar: TButton;
    btnFechar: TButton;
    PanelCliente: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    EditCodigo: TEdit;
    EditDescricao: TEdit;
    btnPesquisa: TButton;
    EditValorUnit: TEdit;
    ImageList: TImageList;
    btnNovo: TButton;
    procedure btnPesquisaClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure EditCodigoKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure EditValorUnitKeyPress(Sender: TObject; var Key: Char);
  private
    FController: IController;
    FProdutos: IProdutoController;

    procedure LimparCampos;
    procedure CarregarCampos(AProduto: IProduto);
    procedure MostrarValidacao(E: EValidacao);
    function MontarProduto: IProduto;
  end;

var
  FProduto: TFProduto;

implementation

uses
  Pesquisa, controller.uController, utils.uEnum;

{$R *.dfm}

procedure TFProduto.MostrarValidacao(E: EValidacao);
begin
  ShowMessage(E.Message);
  if E.Campo = 'DESCRICAO' then
    EditDescricao.SetFocus
  else if E.Campo = 'VALOR_UNITARIO' then
    EditValorUnit.SetFocus;
end;

function TFProduto.MontarProduto: IProduto;
begin
  Result := FProdutos.Novo
    .SetDescricao(EditDescricao.Text)
    .SetPrecoVenda(StrToFloat(EditValorUnit.Text));

  if EditCodigo.Text <> '' then
    Result.SetCodigo(StrToInt(EditCodigo.Text));
end;

procedure TFProduto.btnNovoClick(Sender: TObject);
begin
  LimparCampos;
  EditDescricao.SetFocus;
end;

procedure TFProduto.btnPesquisaClick(Sender: TObject);
var
  FPesquisa : TFPesquisa;
begin
  FPesquisa := TFPesquisa.Create(Self);
  FPesquisa.TipoPesquisa := tpProduto;
  try
    if FPesquisa.ShowModal = mrOk then
      CarregarCampos(FPesquisa.ProdutoSelecionado);
  finally
    FPesquisa.Free;
  end;
end;

procedure TFProduto.btnSalvarClick(Sender: TObject);
var
  lNovo: Boolean;
begin
  lNovo := EditCodigo.Text = '';
  try
    FProdutos.Salvar(MontarProduto);
    if lNovo then
      ShowMessage('Produto cadastrado com sucesso.')
    else
      ShowMessage('Produto atualizado com sucesso.');
    Close;
  except
    on E: EValidacao do
      MostrarValidacao(E);
    on E: EConvertError do
      MostrarValidacao(EValidacao.Create('VALOR_UNITARIO', 'O campo "Valor Unitário" é obrigatório.'));
    on E: Exception do
      ShowMessage('Erro ao salvar o produto. ' + E.Message);
  end;
end;

procedure TFProduto.CarregarCampos(AProduto: IProduto);
begin
  if not Assigned(AProduto) or (AProduto.GetCodigo <= 0) then
  begin
    LimparCampos;
    Exit;
  end;

  EditCodigo.Text    := AProduto.GetCodigo.ToString;
  EditDescricao.Text := AProduto.GetDescricao;
  EditValorUnit.Text := Format('%.2f', [AProduto.GetPrecoVenda]);
end;

procedure TFProduto.EditCodigoKeyPress(Sender: TObject; var Key: Char);
begin
  if key <> #13 then
    Exit;

  if EditCodigo.Text = '' then
    Exit;

  CarregarCampos(FProdutos.Buscar(StrToInt(EditCodigo.Text)));
end;

procedure TFProduto.EditValorUnitKeyPress(Sender: TObject; var Key: Char);
begin
  if not (key in ['0'..'9',',',#8]) then
    key :=#0;
end;

procedure TFProduto.FormCreate(Sender: TObject);
begin
  FController := TController.New;
  FProdutos := FController.Produtos;
end;

procedure TFProduto.LimparCampos;
begin
  EditCodigo.Clear;
  EditDescricao.Clear;
  EditValorUnit.Clear;
end;

procedure TFProduto.btnExcluirClick(Sender: TObject);
begin
  if EditCodigo.Text = '' then
    Exit;

  if MessageDlg('Confirma a exclusão do produto?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    Exit;

  try
    FProdutos.Excluir(StrToInt(EditCodigo.Text));
    ShowMessage('Produto excluído com sucesso.');
    Close;
  except
    on E: EValidacao do
      ShowMessage(E.Message);
    on E: Exception do
      ShowMessage('Erro ao excluir o produto. ' + E.Message);
  end;
end;

procedure TFProduto.btnFecharClick(Sender: TObject);
begin
  Close;
end;

end.
