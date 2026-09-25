program CadastroPedido;

uses
  Vcl.Forms,
  model.entity.uEntity in 'src\model\entity\model.entity.uEntity.pas',
  model.entity.uIEntity in 'src\model\entity\model.entity.uIEntity.pas',
  model.cliente.uCliente in 'src\model\cliente\model.cliente.uCliente.pas',
  model.cliente.uICliente in 'src\model\cliente\model.cliente.uICliente.pas',
  model.produto.uIProduto in 'src\model\produto\model.produto.uIProduto.pas',
  model.produto.uProduto in 'src\model\produto\model.produto.uProduto.pas',
  model.pedido.uIPedido in 'src\model\pedido\model.pedido.uIPedido.pas',
  model.pedido.uPedido in 'src\model\pedido\model.pedido.uPedido.pas',
  model.pedidoItens.uIItensPedido in 'src\model\pedidoItens\model.pedidoItens.uIItensPedido.pas',
  model.pedidoItens.uItensPedido in 'src\model\pedidoItens\model.pedidoItens.uItensPedido.pas',
  Cliente in 'src\View\Cliente.pas' {FCliente},
  Pesquisa in 'src\View\Pesquisa.pas' {FPesquisa},
  Principal in 'src\View\Principal.pas' {FPrincipal},
  Produto in 'src\View\Produto.pas' {FProduto},
  utils.uAtributos in 'src\utils\utils.uAtributos.pas',
  utils.uIMontadorSql in 'src\utils\utils.uIMontadorSql.pas',
  utils.uIUtils in 'src\utils\utils.uIUtils.pas',
  utils.uMontadorSql in 'src\utils\utils.uMontadorSql.pas',
  utils.uMapeador in 'src\utils\utils.uMapeador.pas',
  utils.uRttiHelper in 'src\utils\utils.uRttiHelper.pas',
  utils.uUtils in 'src\utils\utils.uUtils.pas',
  controller.uController in 'src\Controller\controller.uController.pas',
  controller.uIController in 'src\Controller\controller.uIController.pas',
  controller.cliente.uIClienteController in 'src\Controller\cliente\controller.cliente.uIClienteController.pas',
  controller.cliente.uClienteController in 'src\Controller\cliente\controller.cliente.uClienteController.pas',
  controller.produto.uIProdutoController in 'src\Controller\produto\controller.produto.uIProdutoController.pas',
  controller.produto.uProdutoController in 'src\Controller\produto\controller.produto.uProdutoController.pas',
  controller.pedido.uIPedidoController in 'src\Controller\pedido\controller.pedido.uIPedidoController.pas',
  controller.pedido.uPedidoController in 'src\Controller\pedido\controller.pedido.uPedidoController.pas',
  model.dao.uDao in 'src\Model\DAO\model.dao.uDao.pas',
  model.dao.uIDao in 'src\Model\DAO\model.dao.uIDao.pas',
  model.conexao.uConnectionFiredac in 'src\Model\conexao\model.conexao.uConnectionFiredac.pas',
  model.conexao.uSettings in 'src\Model\conexao\model.conexao.uSettings.pas',
  model.conexao.uIConnection in 'src\Model\conexao\model.conexao.uIConnection.pas',
  model.conexao.uISettings in 'src\Model\conexao\model.conexao.uISettings.pas',
  model.conexao.uIQuery in 'src\Model\conexao\model.conexao.uIQuery.pas',
  model.conexao.uQuery in 'src\Model\conexao\model.conexao.uQuery.pas',
  model.cep.uViaCEP in 'src\Model\CEP\model.cep.uViaCEP.pas',
  controller.cep.uIViaCepController in 'src\Controller\CEP\controller.cep.uIViaCepController.pas',
  controller.cep.uViaCepController in 'src\Controller\CEP\controller.cep.uViaCepController.pas',
  model.cep.uIViaCEP in 'src\Model\CEP\model.cep.uIViaCEP.pas',
  model.validacao.uValidacao in 'src\Model\validacao\model.validacao.uValidacao.pas',
  Pedido in 'src\View\Pedido.pas' {FPedido},
  model.totalizador.uTotalizadorValor in 'src\Model\totalizador\model.totalizador.uTotalizadorValor.pas',
  model.totalizador.uITotalizadorValor in 'src\Model\totalizador\model.totalizador.uITotalizadorValor.pas',
  utils.uEnum in 'src\utils\utils.uEnum.pas';

{$R *.res}

begin
//  ReportMemoryLeaksOnShutdown := true;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFPrincipal, FPrincipal);
  Application.Run;
end.
