unit model.produto.uProduto;

interface

uses
  model.produto.uIProduto,
  utils.uAtributos;

type
  [Tabela('PRODUTO')]
  TProduto = class(TInterfacedObject, IProduto)
  private
    [Campo('CODIGO'), PK, Identidade]
    FCodigo: Integer;

    [Campo('DESCRICAO')]
    FDescricao: String;

    [Campo('VALOR_UNITARIO')]
    FPrecoVenda: Currency;

    [Campo('ESTOQUE')]
    FEstoque: Currency;

  public
    class function New: IProduto;

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

uses
  System.SysUtils,
  model.validacao.uValidacao;

class function TProduto.New: IProduto;
begin
  Result := Self.Create;
end;

function TProduto.GetCodigo: Integer;
begin
  Result := FCodigo;
end;

function TProduto.GetDescricao: String;
begin
  Result := FDescricao;
end;

function TProduto.GetPrecoVenda: Currency;
begin
  Result := FPrecoVenda;
end;

function TProduto.GetEstoque: Currency;
begin
  Result := FEstoque;
end;

function TProduto.SetCodigo(const AValue: Integer): IProduto;
begin
  Result := Self;
  FCodigo := AValue;
end;

function TProduto.SetDescricao(const AValue: String): IProduto;
begin
  Result := Self;
  FDescricao := AValue;
end;

function TProduto.SetPrecoVenda(const AValue: Currency): IProduto;
begin
  Result := Self;
  FPrecoVenda := AValue;
end;

function TProduto.SetEstoque(const AValue: Currency): IProduto;
begin
  Result := Self;
  FEstoque := AValue;
end;

procedure TProduto.Validar;
begin
  FDescricao := Trim(FDescricao);
  if FDescricao = '' then
    raise EValidacao.Create('DESCRICAO', 'O campo "Descrição" é obrigatório.');
  if FPrecoVenda <= 0 then
    raise EValidacao.Create('VALOR_UNITARIO', 'O campo "Valor Unitário" é obrigatório.');
end;

procedure TProduto.AplicarOperacao(const ATipo: string; AQuantidade: Currency; AEstorno: Boolean);
var
  lDelta: Currency;
begin
  if ATipo = 'E' then
    lDelta := AQuantidade
  else
    lDelta := -AQuantidade;

  if AEstorno then
    lDelta := -lDelta;

  if (FEstoque + lDelta) < 0 then
    raise EValidacao.Create(
      'ESTOQUE',
      'Estoque insuficiente para o produto ' + FDescricao + '.'
    );

  FEstoque := FEstoque + lDelta;
end;

end.