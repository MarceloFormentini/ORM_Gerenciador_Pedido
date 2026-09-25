unit model.cep.uIViaCEP;

interface

type
  IViaCEP = interface
  ['{D0F614E7-805B-4C9D-AE43-5B1F70AD4C96}']
    function GetCep: string;
    function GetLogradouro: string;
    function GetComplemento: string;
    function GetBairro: string;
    function GetCidade: string;
    function GetUF: string;
    function GetCodigoIBGE: string;

    function SetCep(const AValue: string): IViaCEP;
    function SetLogradouro(const AValue: string): IViaCEP;
    function SetComplemento(const AValue: string): IViaCEP;
    function SetBairro(const AValue: string): IViaCEP;
    function SetCidade(const AValue: string): IViaCEP;
    function SetUF(const AValue: string): IViaCEP;
    function SetCodigoIBGE(const AValue: string): IViaCEP;
 end;

implementation

end.
