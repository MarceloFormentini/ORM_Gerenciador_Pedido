unit model.dao.uDao;

interface

uses
  model.dao.uIDao,
  model.conexao.uIQuery,
  model.conexao.uIConnection,
  Data.DB,
  System.Generics.Collections;

type
  TDao = class(TInterfacedObject, IDao)
  private
    FParent: IInterface;
    FConnection: IConnection;
    FQuery: IQuery;
    FDataSet: TDataSet;
    FLista: TDictionary<String, Variant>;

    procedure DefinirConsulta(ADataSet: TDataSet);
    constructor Create(Parent: IInterface; AConnection: IConnection);
    destructor Destroy; override;

  public
    class function New(Parent: IInterface): IDao; overload;
    class function New(Parent: IInterface; AConnection: IConnection): IDao; overload;

    function Listar: IDao;
    function ListarPorId: IDao;
    function ListarPor(AParam: String): IDao;
    function ListarContendo(AParam: String): IDao;
    function Excluir: IDao;
    function ExcluirPor(AParam: String): IDao;
    function Atualizar: IDao;
    function Inserir: IDao;
    function InserirRetornando(const ACampo: String): Integer;
    function Consulta: TDataSet;
    function Encontrou: Boolean;
    function Materializar: IDao;
    function Relacionado(const ACampo: String): IInterface;
  end;

implementation

uses
  model.conexao.uConnectionFiredac,
  utils.uUtils,
  utils.uIMontadorSql,
  utils.uMapeador,
  System.SysUtils;

function TDao.Atualizar: IDao;
begin
  Result := Self;
  var lQuery := TUtils.New(FParent).MontadorSql.Update;
  FQuery.Query(lQuery, FLista);
end;

constructor TDao.Create(Parent: IInterface; AConnection: IConnection);
begin
  FParent := Parent;
  if Assigned(AConnection) then
    FConnection := AConnection
  else
    FConnection := TConnectionFiredac.New;
  FQuery := FConnection.CriarConsulta;
  FLista := TDictionary<String, Variant>.Create;

  TUtils.New(FParent).MontadorSql.FieldParameter(FLista);
end;

function TDao.Consulta: TDataSet;
begin
  Result := FDataSet;
end;

procedure TDao.DefinirConsulta(ADataSet: TDataSet);
begin
  FDataSet.Free;
  FDataSet := ADataSet;
end;

destructor TDao.Destroy;
begin
  FDataSet.Free;
  FDataSet := nil;
  FLista.Free;
  FLista := nil;
  inherited;
end;

function TDao.Excluir: IDao;
begin
  Result := Self;
  var lQuery := TUtils.New(FParent).MontadorSql.Delete;
  FQuery.Query(lQuery, FLista);
end;

function TDao.ExcluirPor(AParam: String): IDao;
begin
  Result := Self;
  var lQuery := TUtils.New(FParent).MontadorSql.DeleteWhere(AParam);
  FQuery.Query(lQuery, FLista);
end;

function TDao.Encontrou: Boolean;
begin
  Result := Assigned(FDataSet) and (not FDataSet.IsEmpty);
end;

function TDao.Inserir: IDao;
var
  lCampo: String;
begin
  Result := Self;
  if TMapeador.IdentidadePendente(TObject(FParent), lCampo) then
    TMapeador.AtribuirIdentidade(TObject(FParent), InserirRetornando(lCampo))
  else
    FQuery.Query(TUtils.New(FParent).MontadorSql.Insert, FLista);
end;

function TDao.InserirRetornando(const ACampo: String): Integer;
var
  lGerado: TDataSet;
begin
  var lQuery := TUtils.New(FParent).MontadorSql.InsertReturning(ACampo);
  lGerado := nil;
  try
    lGerado := FQuery.OneAll(lQuery, FLista);
    if not Assigned(lGerado) then
      raise Exception.Create('Não foi possível obter o código gerado.');
    if lGerado.IsEmpty then
      raise Exception.Create('Não foi possível obter o código gerado.');

    Result := lGerado.FieldByName(ACampo).AsInteger;
    if Result <= 0 then
      raise Exception.Create('Não foi possível obter o código gerado.');
  finally
    lGerado.Free;
  end;
end;

function TDao.Materializar: IDao;
begin
  Result := Self;
  TMapeador.Preencher(TObject(FParent), FDataSet);
end;

function TDao.Relacionado(const ACampo: String): IInterface;
var
  lObjeto: TObject;
  lDao: IDao;
begin
  Result := nil;
  lObjeto := TMapeador.CriarRelacionado(TObject(FParent), ACampo);
  if not Assigned(lObjeto) then
    Exit;

  if not Supports(lObjeto, IInterface, Result) then
  begin
    lObjeto.Free;
    Exit;
  end;
  lDao := TDao.New(Result, FConnection).ListarPorId;
  if not lDao.Encontrou then
  begin
    Result := nil;
    Exit;
  end;

  lDao.Materializar;
end;

function TDao.Listar: IDao;
begin
  Result := Self;
  var lQuery := TUtils.New(FParent).MontadorSql.SelectWithWhere(False);
  DefinirConsulta(FQuery.OneAll(lQuery, []));
end;

function TDao.ListarPor(AParam: String): IDao;
begin
  Result := Self;
  var lQuery := TUtils.New(FParent).MontadorSql.SelectWithFixedWhere(AParam);
  DefinirConsulta(FQuery.OneAll(lQuery, FLista));
end;

function TDao.ListarContendo(AParam: String): IDao;
begin
  Result := Self;
  var lQuery := TUtils.New(FParent).MontadorSql.SelectContaining(AParam);
  DefinirConsulta(FQuery.OneAll(lQuery, FLista));
end;

function TDao.ListarPorId: IDao;
begin
  Result := Self;
  var lQuery := TUtils.New(FParent).MontadorSql.SelectWithWhere(True);
  DefinirConsulta(FQuery.OneAll(lQuery, FLista));
end;

class function TDao.New(Parent: IInterface): IDao;
begin
  Result := Self.Create(Parent, nil);
end;

class function TDao.New(Parent: IInterface; AConnection: IConnection): IDao;
begin
  Result := Self.Create(Parent, AConnection);
end;

end.
