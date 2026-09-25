unit model.totalizador.uTotalizadorValor;

interface

uses
  model.totalizador.uITotalizadorValor, Data.DB;

type
  TTotalizadorValor = class(TInterfacedObject, ITotalizadorValor)
  private
    FDataSet: TDataSet;

    constructor Create(ADataSet: TDataSet);
    destructor Destroy; override;
  public
    class function New(ADataSet: TDataSet): ITotalizadorValor;
    function CalcularTotal: String;
  end;

implementation

uses
  System.SysUtils;

function TTotalizadorValor.CalcularTotal: String;
var
  total: Double;
  bookmark: TBookmark;
begin
  total := 0;
  bookmark := nil;
  FDataSet.DisableControls;
  try
    if not FDataSet.IsEmpty then
      bookmark := FDataSet.GetBookmark;

    FDataSet.First;
    while not FDataSet.Eof do
    begin
      total := total + FDataSet.FieldByName('TOTAL_ITEM').AsFloat;
      FDataSet.Next;
    end;
  finally
    if (bookmark <> nil) and FDataSet.BookmarkValid(bookmark) then
      FDataSet.GotoBookmark(bookmark);
    FDataSet.FreeBookmark(bookmark);
    FDataSet.EnableControls;
  end;
  Result := Format('%.2f', [total]);
end;

constructor TTotalizadorValor.Create(ADataSet: TDataSet);
begin
  FDataSet := ADataSet;
end;

destructor TTotalizadorValor.Destroy;
begin

  inherited;
end;

class function TTotalizadorValor.New(ADataSet: TDataSet): ITotalizadorValor;
begin
  Result := Self.Create(ADataSet);
end;

end.
