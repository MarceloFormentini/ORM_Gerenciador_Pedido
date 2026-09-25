unit controller.cliente.uIClienteController;

interface

uses
  model.cliente.uICliente;

type
  IClienteController = interface
  ['{7B4E1C2A-9D63-4F18-A5E0-1C8B6D4F2A90}']
    function Novo: ICliente;
    function Buscar(ACodigo: Integer): ICliente;
    function Listar: TArray<ICliente>;
    function PesquisarPorNome(const ANome: string): TArray<ICliente>;
    procedure Salvar(ACliente: ICliente);
    procedure Excluir(ACodigo: Integer);
  end;

implementation

end.
