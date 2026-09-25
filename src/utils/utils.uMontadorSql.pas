unit utils.uMontadorSql;

interface

uses
  utils.uIMontadorSql,
  System.Generics.Collections;

type
  TMontadorSql = class(TInterfacedObject, IMontadorSql)
  private
    FParent: TObject;

    function NomeTabela: String;
    function JuntarCampos(AAtualizacao: Boolean; const AModelo: String): String;
    function Where: String;

    constructor Create(Parent: IInterface);

  public
    class function New(Parent: IInterface): IMontadorSql;

    procedure FieldParameter(var AValue: TDictionary<String, Variant>);
    function SelectWithWhere(AValue: Boolean): string;
    function SelectWithFixedWhere(AParam: String): string;
    function SelectContaining(AParam: String): string;
    function Insert: String;
    function InsertReturning(const ACampo: String): String;
    function Update: String;
    function Delete: String;
    function DeleteWhere(AParam: String): String;

  end;

implementation

uses
  System.Rtti,
  System.SysUtils,
  System.TypInfo,
  utils.uRttiHelper,
  utils.uAtributos;

type
  TInclusaoCampo = (icInsert, icUpdateSet, icParametro);

constructor TMontadorSql.Create(Parent: IInterface);
begin
  FParent := TObject(Parent);
end;

function ValorDoCampo(AField: TRttiField; AParent: TObject): Variant;
begin
  case AField.GetValue(AParent).TypeInfo.Kind of
    tkInteger, tkInt64:
      Result := AField.GetValue(AParent).AsInteger;
    tkFloat:
      if AField.GetValue(AParent).TypeInfo = TypeInfo(TDateTime) then
        Result := AField.GetValue(AParent).AsType<TDateTime>
      else
        Result := AField.GetValue(AParent).AsCurrency;
  else
    Result := AField.GetValue(AParent).AsString;
  end;
end;

function IdentidadeSemValor(AField: TRttiField; AParent: TObject): Boolean;
begin
  Result := AField.Tem<Identidade>
    and (AField.GetValue(AParent).Kind in [tkInteger, tkInt64])
    and (AField.GetValue(AParent).AsInteger <= 0);
end;

function IncluirCampo(AField: TRttiField; AParent: TObject; AInclusao: TInclusaoCampo): Boolean;
begin
  Result := False;
  if not AField.Tem<Campo> then
    Exit;

  if (AInclusao = icUpdateSet) and AField.Tem<PK> then
    Exit;

  if (AInclusao = icInsert) and IdentidadeSemValor(AField, AParent) then
    Exit;

  Result := True;
end;

procedure ParaCadaCampo(AParent: TObject; AInclusao: TInclusaoCampo; AAcao: TProc<TRttiField>);
var
  lContexto: TRttiContext;
  lTipo: TRttiType;
  lCampo: TRttiField;
begin
  lContexto := TRttiContext.Create;
  try
    lTipo := lContexto.GetType(AParent.ClassInfo);
    for lCampo in lTipo.GetFields do
    begin
      if not IncluirCampo(lCampo, AParent, AInclusao) then
        Continue;

      AAcao(lCampo);
    end;
  finally
    lContexto.Free;
  end;
end;

function TMontadorSql.JuntarCampos(AAtualizacao: Boolean; const AModelo: String): String;
var
  lInclusao: TInclusaoCampo;
  lTexto: String;
begin
  if AAtualizacao then
    lInclusao := icUpdateSet
  else
    lInclusao := icInsert;

  lTexto := '';
  ParaCadaCampo(FParent, lInclusao,
    procedure(AField: TRttiField)
    var
      lNome: String;
    begin
      lNome := AField.GetAttribute<Campo>.Name;
      lTexto := lTexto + Format(AModelo, [lNome, lNome]);
    end);

  Result := Copy(lTexto, 1, Length(lTexto) - 2);
end;

procedure TMontadorSql.FieldParameter(var AValue: TDictionary<String, Variant>);
var
  lLista: TDictionary<String, Variant>;
begin
  lLista := AValue;
  ParaCadaCampo(FParent, icParametro,
    procedure(AField: TRttiField)
    begin
      lLista.Add(AField.GetAttribute<Campo>.Name, ValorDoCampo(AField, FParent));
    end);
end;

class function TMontadorSql.New(Parent: IInterface): IMontadorSql;
begin
  Result := Self.Create(Parent);
end;

function TMontadorSql.SelectWithFixedWhere(AParam: String): string;
begin
  Result := 'SELECT * FROM ' + NomeTabela;

  if AParam <> '' then
    Result := Result + ' WHERE ' + AParam + ' = :' + AParam;
end;

function TMontadorSql.SelectContaining(AParam: String): string;
begin
  Result := 'SELECT * FROM ' + NomeTabela;

  if AParam <> '' then
    Result := Result + ' WHERE ' + AParam + ' CONTAINING :' + AParam;
end;

function TMontadorSql.SelectWithWhere(AValue: Boolean): string;
begin
  Result := 'SELECT * FROM ' + NomeTabela;

  if AValue then
    Result := Result + ' WHERE ' + Where;
end;

function TMontadorSql.NomeTabela: String;
var
  vCtxRtti: TRttiContext;
  vTypRtti: TRttiType;
begin
  vCtxRtti := TRttiContext.Create;
  try
    vTypRtti := vCtxRtti.GetType(FParent.ClassInfo);

    if vTypRtti.Tem<Tabela> then
      Result := vTypRtti.GetAttribute<Tabela>.Name;

  finally
    vCtxRtti.Free;
  end;
end;

function TMontadorSql.Insert: String;
begin
  Result := 'INSERT INTO ' + NomeTabela + ' (' + JuntarCampos(False, '%s, ') +
    ') VALUES (' + JuntarCampos(False, ':%s, ') + ')';
end;

function TMontadorSql.InsertReturning(const ACampo: String): String;
begin
  Result := Insert + ' RETURNING ' + ACampo;
end;

function TMontadorSql.Update: String;
begin
  Result := 'UPDATE ' + NomeTabela + ' SET ' + JuntarCampos(True, '%s = :%s, ') +
    ' WHERE ' + Where;
end;

function TMontadorSql.Where: String;
var
  lCtxRtti: TRttiContext;
  lTipo: TRttiType;
  lTexto: String;
  lCampo: TRttiField;
begin
  lTexto := '';

  lCtxRtti := TRttiContext.Create;
  try
    lTipo := lCtxRtti.GetType(FParent.ClassInfo);

    for lCampo in lTipo.GetFields do
    begin
      if not lCampo.Tem<Campo> then
        Continue;
      if not lCampo.Tem<PK> then
        Continue;

      lTexto := lTexto + lCampo.GetAttribute<Campo>.Name + ' = :' +
        lCampo.GetAttribute<Campo>.Name + ' AND ';
    end;
  finally
    Result := Copy(lTexto, 1, Length(lTexto) - 5);
    lCtxRtti.Free;
  end;
end;

function TMontadorSql.Delete: String;
begin
  Result := 'DELETE FROM ' + NomeTabela + ' WHERE ' + Where;
end;

function TMontadorSql.DeleteWhere(AParam: String): String;
begin
  Result := 'DELETE FROM ' + NomeTabela + ' WHERE ' + AParam + ' = :' + AParam;
end;

end.
