unit model.pedido.uPedido;

interface

uses
  model.pedido.uIPedido,
  model.cliente.uCliente,
  model.pedidoItens.uIItensPedido,
  System.Generics.Collections,
  utils.uAtributos;

type
  [Tabela('PEDIDO')]
  TPedido = class(TInterfacedObject, IPedido)
  private
    [Campo('CODIGO'), PK, Identidade]
    FCodigo: Integer;

    [Campo('REFERENCIA')]
    FReferencia: String;

    [Campo('NUMERO_PEDIDO')]
    FNumeroPedido: String;

    [Campo('DATA_EMISSAO')]
    FDataEmissao: TDateTime;

    [Campo('CODIGO_CLIENTE'), Relacionamento(TCliente)]
    FCodigoCliente: Integer;

    [Campo('TIPO_OPERACAO')]
    FTipoPedido: String;

    [Campo('TOTAL_PEDIDO')]
    FValorTotal: Currency;

    FItens: TList<IItensPedido>;

  public
    constructor Create;
    destructor Destroy; override;
    class function New: IPedido;

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

uses
  System.SysUtils,
  model.validacao.uValidacao;

constructor TPedido.Create;
begin
  inherited;
  FItens := TList<IItensPedido>.Create;
end;

destructor TPedido.Destroy;
begin
  FItens.Free;
  inherited;
end;

class function TPedido.New: IPedido;
begin
  Result := Self.Create;
end;

function TPedido.Itens: TList<IItensPedido>;
begin
  Result := FItens;
end;

function TPedido.AdicionarItem(AItem: IItensPedido): IPedido;
begin
  Result := Self;
  FItens.Add(AItem);
end;

procedure TPedido.ValidarCabecalho;
begin
  FNumeroPedido := Trim(FNumeroPedido);
  FReferencia := Trim(FReferencia);

  if FNumeroPedido = '' then
    raise EValidacao.Create('NUMERO_PEDIDO', 'O campo "Numero Pedido" é obrigatório.');
  if FReferencia = '' then
    raise EValidacao.Create('REFERENCIA', 'O campo "Referência" é obrigatório.');
  if FDataEmissao = 0 then
    raise EValidacao.Create('DATA_EMISSAO', 'O campo "Data Emissão" é obrigatório.');
  if FCodigoCliente <= 0 then
    raise EValidacao.Create('CODIGO_CLIENTE', 'O campo "Cliente" é obrigatório.');
  if (FTipoPedido <> 'E') and (FTipoPedido <> 'S') then
    raise EValidacao.Create('TIPO_OPERACAO', 'O tipo do pedido deve ser Entrada ou Saída.');
end;

procedure TPedido.Validar;
var
  lItem: IItensPedido;
begin
  ValidarCabecalho;

  if FItens.Count = 0 then
    raise EValidacao.Create('ITENS', 'Informe os itens do pedido para poder salvar.');

  FValorTotal := 0;
  for lItem in FItens do
  begin
    lItem.Validar;
    FValorTotal := FValorTotal + lItem.GetValorTotal;
  end;
end;

function TPedido.GetCodigo: Integer;
begin
  Result := FCodigo;
end;

function TPedido.GetCodigoCliente: Integer;
begin
  Result := FCodigoCliente;
end;

function TPedido.GetDataEmissao: TDateTime;
begin
  Result := FDataEmissao;
end;

function TPedido.GetNumeroPedido: String;
begin
  Result := FNumeroPedido;
end;

function TPedido.GetReferencia: String;
begin
  Result := FReferencia;
end;

function TPedido.GetTipoPedido: String;
begin
  Result := FTipoPedido;
end;

function TPedido.GetValorTotal: Currency;
begin
  Result := FValorTotal;
end;

function TPedido.SetCodigo(const AValue: Integer): IPedido;
begin
  Result := Self;
  FCodigo := AValue;
end;

function TPedido.SetCodigoCliente(const AValue: Integer): IPedido;
begin
  Result := Self;
  FCodigoCliente := AValue;
end;

function TPedido.SetDataEmissao(AValue: TDateTime): IPedido;
begin
  Result := Self;
  FDataEmissao := AValue;
end;

function TPedido.SetNumeroPedido(const AValue: String): IPedido;
begin
  Result := Self;
  FNumeroPedido := AValue;
end;

function TPedido.SetReferencia(const AValue: String): IPedido;
begin
  Result := Self;
  FReferencia := AValue;
end;

function TPedido.SetTipoPedido(const AValue: String): IPedido;
begin
  Result := Self;
  FTipoPedido := AValue;
end;

function TPedido.SetValorTotal(const AValue: Currency): IPedido;
begin
  Result := Self;
  FValorTotal := AValue;
end;

end.
