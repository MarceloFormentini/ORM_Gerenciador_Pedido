unit model.cliente.uICliente;

interface

type
  ICliente = interface
  ['{C4E8A1D2-6B37-4F0A-9E15-2D8A7C41B6F0}']
    function GetCodigo: Integer;
    function GetNome: string;
    function GetCEP: string;
    function GetLogradouro: string;
    function GetComplemento: string;
    function GetBairro: string;
    function GetCidade: string;
    function GetUF: string;
    function GetCodigoIBGE: string;

    function SetCodigo(const AValue: Integer): ICliente;
    function SetNome(const AValue: string): ICliente;
    function SetCEP(const AValue: string): ICliente;
    function SetLogradouro(const AValue: string): ICliente;
    function SetComplemento(const AValue: string): ICliente;
    function SetBairro(const AValue: string): ICliente;
    function SetCidade(const AValue: string): ICliente;
    function SetUF(const AValue: string): ICliente;
    function SetCodigoIBGE(const AValue: string): ICliente;

    procedure Validar;
  end;

implementation

end.
