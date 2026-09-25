unit model.conexao.uIConnection;

interface

uses
  model.conexao.uIQuery;

type

  IConnection = interface
  ['{B8D4F2C5-6E39-4A7B-8C21-3F9D5E8B2A74}']
    function CriarConsulta: IQuery;
    procedure IniciarTransacao;
    procedure ConfirmarTransacao;
    procedure CancelarTransacao;
  end;

implementation

end.
