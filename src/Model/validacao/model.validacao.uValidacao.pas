unit model.validacao.uValidacao;

interface

uses
  System.SysUtils;

type
  EValidacao = class(Exception)
  private
    FCampo: string;
  public
    constructor Create(const ACampo, AMensagem: string);
    property Campo: string read FCampo;
  end;

implementation

constructor EValidacao.Create(const ACampo, AMensagem: string);
begin
  inherited Create(AMensagem);
  FCampo := ACampo;
end;

end.
