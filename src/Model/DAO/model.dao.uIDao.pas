unit model.dao.uIDao;

interface

uses
  Data.DB;

type
  IDao = interface
  ['{A7C3E1B4-5D28-4F6A-9B10-2E8C4D7A1F63}']
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

end.
