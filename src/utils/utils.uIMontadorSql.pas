unit utils.uIMontadorSql;

interface

uses
  System.Generics.Collections;

type
  IMontadorSql = interface
  ['{4CC8B0E7-DC88-4138-B407-7FFC625AF8A5}']
    function Insert: String;
    function InsertReturning(const ACampo: String): String;
    function Update: String;
    function Delete: String;
    function DeleteWhere(AParam: String): String;
    procedure FieldParameter(var AValue: TDictionary<String, Variant>);
    function SelectWithWhere(AValue: Boolean): String;
    function SelectWithFixedWhere(AParam: String): string;
    function SelectContaining(AParam: String): string;
  end;

implementation

end.
