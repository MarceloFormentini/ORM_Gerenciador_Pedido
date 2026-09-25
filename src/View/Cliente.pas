unit Cliente;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.ImageList, Vcl.ImgList,
  Vcl.StdCtrls, Vcl.ExtCtrls,
  Pesquisa, Vcl.Mask, Vcl.DBCtrls, Datasnap.DBClient, Data.DB,
  controller.cep.uIViaCepController, controller.cep.uViaCepController,
  controller.uIController, controller.cliente.uIClienteController, model.cliente.uICliente,
  model.validacao.uValidacao;

type
  TFCliente = class(TForm)
    PanelCliente: TPanel;
    PanelBottom: TPanel;
    btnExcluir: TButton;
    btnSalvar: TButton;
    btnFechar: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    EditCodigo: TEdit;
    EditNome: TEdit;
    Label5: TLabel;
    btnPesquisa: TButton;
    ImageList: TImageList;
    EditUF: TEdit;
    EditCidade: TEdit;
    Label6: TLabel;
    EditCEP: TEdit;
    btnConsultarCEP: TButton;
    Label7: TLabel;
    EditLogradouro: TEdit;
    Label8: TLabel;
    EditComplemento: TEdit;
    Label9: TLabel;
    EditBairro: TEdit;
    Label10: TLabel;
    EditCodigoIBGE: TEdit;
    btnNovo: TButton;
    procedure btnPesquisaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure EditCodigoKeyPress(Sender: TObject; var Key: Char);
    procedure btnFecharClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnConsultarCEPClick(Sender: TObject);
  private
    FController: IController;
    FClientes: IClienteController;
    FViaCEPController: IViaCepController;

    procedure LimparCampos;
    procedure CarregarCampos(ACliente: ICliente);
    procedure MostrarValidacao(E: EValidacao);
    function MontarCliente: ICliente;
  end;

var
  FCliente: TFCliente;

implementation

uses
  controller.uController, model.cep.uViaCEP, model.cep.uIViaCEP,
  utils.uEnum;

{$R *.dfm}

procedure TFCliente.MostrarValidacao(E: EValidacao);
begin
  ShowMessage(E.Message);
  if E.Campo = 'NOME' then
    EditNome.SetFocus
  else if E.Campo = 'CEP' then
    EditCEP.SetFocus
  else if E.Campo = 'LOGRADOURO' then
    EditLogradouro.SetFocus
  else if E.Campo = 'BAIRRO' then
    EditBairro.SetFocus
  else if E.Campo = 'CIDADE' then
    EditCidade.SetFocus
  else if E.Campo = 'UF' then
    EditUF.SetFocus
  else if E.Campo = 'CODIGO_IBGE' then
    EditCodigoIBGE.SetFocus;
end;

function TFCliente.MontarCliente: ICliente;
begin
  Result := FClientes.Novo
    .SetNome(EditNome.Text)
    .SetCEP(EditCEP.Text)
    .SetLogradouro(EditLogradouro.Text)
    .SetComplemento(EditComplemento.Text)
    .SetBairro(EditBairro.Text)
    .SetCidade(EditCidade.Text)
    .SetUF(EditUF.Text)
    .SetCodigoIBGE(EditCodigoIBGE.Text);

  if EditCodigo.Text <> '' then
    Result.SetCodigo(StrToInt(EditCodigo.Text));
end;

procedure TFCliente.btnConsultarCEPClick(Sender: TObject);
var
  ConsultaCEP: IViaCep;
begin
  if EditCEP.Text = '' then
    Exit;

  FViaCEPController := TViaCepController.New;
  try
    ConsultaCEP := FViaCEPController.ConsultarPorCEP(EditCEP.Text);
  except
    on E: Exception do
    begin
      ShowMessage(E.Message);
      Exit;
    end;
  end;

  EditLogradouro.Text := ConsultaCEP.GetLogradouro;
  EditComplemento.Text := ConsultaCEP.GetComplemento;
  EditBairro.Text := ConsultaCEP.GetBairro;
  EditCidade.Text := ConsultaCEP.GetCidade;
  EditUF.Text := ConsultaCEP.GetUF;
  EditCodigoIBGE.Text := ConsultaCEP.GetCodigoIBGE;
end;

procedure TFCliente.btnExcluirClick(Sender: TObject);
begin
  if EditCodigo.Text = '' then
    Exit;

  if MessageDlg('Confirma a exclusão do cliente?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    Exit;

  try
    FClientes.Excluir(StrToInt(EditCodigo.Text));
    ShowMessage('Cliente excluído com sucesso.');
    Close;
  except
    on E: EValidacao do
      ShowMessage(E.Message);
    on E: Exception do
      ShowMessage('Erro ao excluir o cliente. ' + E.Message);
  end;
end;

procedure TFCliente.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TFCliente.btnNovoClick(Sender: TObject);
begin
  LimparCampos;
  EditNome.SetFocus;
end;

procedure TFCliente.btnPesquisaClick(Sender: TObject);
var
  FPesquisa: TFPesquisa;
begin
  FPesquisa := TFPesquisa.Create(Self);
  FPesquisa.TipoPesquisa := tpCliente;
  try
    if FPesquisa.ShowModal = mrOk then
      CarregarCampos(FPesquisa.ClienteSelecionado);
  finally
    FPesquisa.Free;
  end;
end;

procedure TFCliente.btnSalvarClick(Sender: TObject);
var
  lNovo: Boolean;
begin
  lNovo := EditCodigo.Text = '';
  try
    FClientes.Salvar(MontarCliente);
    if lNovo then
      ShowMessage('Cliente cadastrado com sucesso.')
    else
      ShowMessage('Cliente atualizado com sucesso.');
  except
    on E: EValidacao do
      MostrarValidacao(E);
    on E: Exception do
      ShowMessage('Erro ao salvar o cliente. ' + E.Message);
  end;
end;

procedure TFCliente.CarregarCampos(ACliente: ICliente);
begin
  if not Assigned(ACliente) or (ACliente.GetCodigo <= 0) then
  begin
    LimparCampos;
    Exit;
  end;

  EditCodigo.Text       := ACliente.GetCodigo.ToString;
  EditNome.Text         := ACliente.GetNome;
  EditCEP.Text          := ACliente.GetCEP;
  EditLogradouro.Text   := ACliente.GetLogradouro;
  EditComplemento.Text  := ACliente.GetComplemento;
  EditBairro.Text       := ACliente.GetBairro;
  EditCidade.Text       := ACliente.GetCidade;
  EditUF.Text           := ACliente.GetUF;
  EditCodigoIBGE.Text   := ACliente.GetCodigoIBGE;
end;

procedure TFCliente.EditCodigoKeyPress(Sender: TObject; var Key: Char);
begin
  if key <> #13 then
    Exit;

  if EditCodigo.Text = '' then
    Exit;

  CarregarCampos(FClientes.Buscar(StrToInt(EditCodigo.Text)));
end;

procedure TFCliente.FormCreate(Sender: TObject);
begin
  FController := TController.New;
  FClientes := FController.Clientes;
end;

procedure TFCliente.LimparCampos;
begin
  EditCodigo.Clear;
  EditNome.Clear;
  EditCEP.Clear;
  EditLogradouro.Clear;
  EditComplemento.Clear;
  EditBairro.Clear;
  EditCidade.Clear;
  EditUF.Clear;
  EditCodigoIBGE.Clear;
end;

end.
