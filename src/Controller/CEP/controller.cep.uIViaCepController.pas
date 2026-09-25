unit controller.cep.uIViaCepController;

interface

uses
  model.cep.uIViaCEP;

type
  IViaCepController = interface
  ['{E10725F8-916C-4DAE-BF54-6C2081BE5DA7}']
    function ConsultarPorCEP(const ACep: string): IViaCep;
  end;

implementation

end.
