unit utils.uAtributos;

interface

uses
  System.Rtti;

type
  Campo = class(TCustomAttribute)
    private
      FName: String;

    public
      constructor Create(AName: String);
      property Name: String read FName;
  end;

  Tabela = class(TCustomAttribute)
    private
      FName: String;

    public
      constructor Create(AName: String);
      property Name: String read FName;
  end;

  PK = class(TCustomAttribute)
  end;

  Identidade = class(TCustomAttribute)
  end;

  Relacionamento = class(TCustomAttribute)
  private
    FClasse: TClass;
  public
    constructor Create(AClasse: TClass);
    property Classe: TClass read FClasse;
  end;

implementation

{ Campo }

constructor Campo.Create(AName: String);
begin
  FName := AName;
end;

{ Tabela }

constructor Tabela.Create(AName: String);
begin
  FName := AName;

end;

{ Relacionamento }

constructor Relacionamento.Create(AClasse: TClass);
begin
  FClasse := AClasse;
end;

end.
