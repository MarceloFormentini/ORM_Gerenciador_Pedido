unit utils.uIUtils;

interface

uses
  utils.uIMontadorSql;

type
  IUtils = interface
  ['{D2B3F4F8-E1B4-49BA-8610-69282D9393C1}']
    function MontadorSql: IMontadorSql;
  end;

implementation

end.
