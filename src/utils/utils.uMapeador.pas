unit utils.uMapeador;

interface

uses
  System.Rtti,
  Data.DB;

type
  TMapeador = class
  public
    class procedure Preencher(AObjeto: TObject; ADataSet: TDataSet);
    class function IdentidadePendente(AObjeto: TObject; out ACampo: String): Boolean;
    class procedure AtribuirIdentidade(AObjeto: TObject; AValor: Integer);
    class function CriarRelacionado(AObjeto: TObject; const ACampo: String): TObject;
  end;

implementation

uses
  System.SysUtils,
  System.TypInfo,
  utils.uAtributos,
  utils.uRttiHelper;

class procedure TMapeador.AtribuirIdentidade(AObjeto: TObject; AValor: Integer);
var
  lContexto: TRttiContext;
  lTipo: TRttiType;
  lCampo: TRttiField;
begin
  lContexto := TRttiContext.Create;
  try
    lTipo := lContexto.GetType(AObjeto.ClassInfo);
    for lCampo in lTipo.GetFields do
    begin
      if not lCampo.Tem<Identidade> then
        Continue;

      lCampo.SetValue(AObjeto, AValor);
      Exit;
    end;
  finally
    lContexto.Free;
  end;
end;

class function TMapeador.CriarRelacionado(AObjeto: TObject; const ACampo: String): TObject;
var
  lContexto: TRttiContext;
  lTipo: TRttiType;
  lCampo: TRttiField;
  lRelacao: Relacionamento;
  lValor: Integer;
  lPk: TRttiField;
begin
  Result := nil;
  lContexto := TRttiContext.Create;
  try
    lTipo := lContexto.GetType(AObjeto.ClassInfo);
    for lCampo in lTipo.GetFields do
    begin
      if not lCampo.Tem<Campo> then
        Continue;
      if not SameText(lCampo.GetAttribute<Campo>.Name, ACampo) then
        Continue;
      if not lCampo.Tem<Relacionamento> then
        Exit;

      lValor := lCampo.GetValue(AObjeto).AsInteger;
      if lValor <= 0 then
        Exit;

      lRelacao := lCampo.GetAttribute<Relacionamento>;
      Result := lRelacao.Classe.Create;
      lTipo := lContexto.GetType(Result.ClassInfo);
      for lPk in lTipo.GetFields do
      begin
        if not lPk.Tem<Identidade> then
          Continue;

        lPk.SetValue(Result, lValor);
        Exit;
      end;
      Exit;
    end;
  finally
    lContexto.Free;
  end;
end;

class function TMapeador.IdentidadePendente(AObjeto: TObject; out ACampo: String): Boolean;
var
  lContexto: TRttiContext;
  lTipo: TRttiType;
  lCampo: TRttiField;
begin
  Result := False;
  ACampo := '';
  lContexto := TRttiContext.Create;
  try
    lTipo := lContexto.GetType(AObjeto.ClassInfo);
    for lCampo in lTipo.GetFields do
    begin
      if not lCampo.Tem<Identidade> then
        Continue;

      ACampo := lCampo.GetAttribute<Campo>.Name;
      Result := lCampo.GetValue(AObjeto).AsInteger <= 0;
      Exit;
    end;
  finally
    lContexto.Free;
  end;
end;

class procedure TMapeador.Preencher(AObjeto: TObject; ADataSet: TDataSet);
var
  lContexto: TRttiContext;
  lTipo: TRttiType;
  lCampo: TRttiField;
  lColuna: TField;
  lNome: String;
begin
  if not Assigned(ADataSet) or ADataSet.IsEmpty then
    Exit;

  lContexto := TRttiContext.Create;
  try
    lTipo := lContexto.GetType(AObjeto.ClassInfo);
    for lCampo in lTipo.GetFields do
    begin
      if not lCampo.Tem<Campo> then
        Continue;

      lNome := lCampo.GetAttribute<Campo>.Name;
      lColuna := ADataSet.FindField(lNome);
      if not Assigned(lColuna) or lColuna.IsNull then
        Continue;

      case lCampo.FieldType.TypeKind of
        tkInteger, tkInt64:
          lCampo.SetValue(AObjeto, lColuna.AsInteger);
        tkFloat:
          if lCampo.FieldType.Handle = TypeInfo(TDateTime) then
            lCampo.SetValue(AObjeto, lColuna.AsDateTime)
          else
            lCampo.SetValue(AObjeto, lColuna.AsCurrency);
      else
        lCampo.SetValue(AObjeto, lColuna.AsString);
      end;
    end;
  finally
    lContexto.Free;
  end;
end;

end.
