unit utils.uUtils;

interface

uses
  utils.uIUtils,
  utils.uIMontadorSql;

type
  TUtils = class(TInterfacedObject, IUtils)
  private
    FParent: IInterface;
    FMontadorSql: IMontadorSql;

  public
    constructor Create(Parent: IInterface);
    destructor Destroy; override;
    class function New(Parent: IInterface): IUtils;
    function MontadorSql: IMontadorSql;

  end;

implementation

uses
  utils.uMontadorSql;

constructor TUtils.Create(Parent: IInterface);
begin
  FParent := Parent;
end;

destructor TUtils.Destroy;
begin

  inherited;
end;

class function TUtils.New(Parent: IInterface): IUtils;
begin
  Result := Self.Create(Parent);
end;

function TUtils.MontadorSql: IMontadorSql;
begin
  if not Assigned(FMontadorSql) then
    FMontadorSql := TMontadorSql.New(FParent);

  Result := FMontadorSql;
end;

end.
