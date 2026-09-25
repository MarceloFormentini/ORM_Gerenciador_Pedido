# Gerenciador de Pedido

Aplicação desktop em Delphi para cadastrar clientes e produtos e registrar pedidos de entrada e de saída. O estoque do produto é movimentado junto com o pedido, dentro de uma transação.

O projeto usa MVC com orientação a interfaces e um mapeamento objeto-relacional feito com RTTI: atributos nas classes descrevem tabela, campos, chave e relacionamento, e o DAO monta o SQL a partir desses metadados.

## Funcionalidades

- **Clientes.** Inclusão, alteração, exclusão e pesquisa por nome. O endereço pode ser preenchido pela consulta do CEP na API ViaCEP (`https://viacep.com.br`).
- **Produtos.** Inclusão, alteração, exclusão e pesquisa por descrição. O valor unitário é informado no cadastro. O estoque não é editado nessa tela: ele começa em zero e só muda quando um pedido é gravado, alterado ou excluído.
- **Pedidos.** Cabeçalho com número, referência, data de emissão, cliente e tipo de operação (entrada ou saída), mais os itens (produto, quantidade e valor unitário). O total do item e o total do pedido são calculados na gravação.
- **Pesquisa.** Formulário compartilhado para localizar cliente, produto ou pedido e devolver o registro selecionado à tela de origem.
- **Validações.** Regras de obrigatoriedade e de estoque disparam `EValidacao`, e a tela destaca o campo correspondente.

## Tecnologias

| Item | Uso no projeto |
| --- | --- |
| Delphi 10.3 Rio (VCL, Win32) | Interface e compilação. O arquivo de projeto é `CadastroPedido.dproj` (versão de projeto 19.2). |
| FireDAC | Conexão, consultas e pool. O componente do driver fica isolado em `TConnectionFiredac`. |
| Firebird | Banco de dados. Os scripts usam generators, triggers e `CONTAINING`. |
| RTTI e atributos customizados | Mapeamento das entidades para SQL e preenchimento dos objetos a partir do `TDataSet`. |
| ViaCEP | Consulta de endereço por CEP no cadastro de cliente. |

## Arquitetura

A separação segue Model, View e Controller. A view não monta SQL e não conhece `TFDConnection`. Ela chama o controller, que opera sobre interfaces de entidade e devolve objetos já materializados.

```
View (formulários VCL)
        |
        v
Controller (casos de uso: salvar, buscar, excluir, consultar CEP)
        |
        +--> IEntity          fábrica das entidades
        +--> IDao             persistência genérica
                |
                +--> IMontadorSql   SQL gerado por RTTI
                +--> TMapeador      dataset -> objeto
                +--> IConnection    transação e consulta (FireDAC)
```

### Contratos principais

- **IEntity.** Localizador das entidades. O controller guarda uma instância e a devolve em `Entity`. Cada acesso (`Cliente`, `Produto`, `Pedido`, `PedidoItens`) cria um objeto novo pela fábrica registrada. A fábrica padrão chama o `New` concreto. Para teste ou outra implementação, use `TEntity.UsarCliente` (e os equivalentes) ou passe outro `IEntity` em `TController.New`.
- **IController.** Ponto de entrada da aplicação de negócio: `Clientes`, `Produtos` e `Pedidos`. `TController.New` também aceita uma fábrica de DAO (`TFabricaDao`), o que permite trocar a persistência sem alterar a view.
- **IDao.** Persistência da entidade recebida no construtor. Oferece listar, listar por chave, listar por campo, listar contendo texto, inserir, atualizar, excluir, `Materializar` (copia o dataset para o objeto) e `Relacionado` (instancia a entidade ligada por um campo). `Consulta` devolve o `TDataSet` do resultado.
- **IConnection.** Contrato da conexão: `IniciarTransacao`, `ConfirmarTransacao`, `CancelarTransacao` e `CriarConsulta`. O `TFDConnection` permanece privado em `TConnectionFiredac`.
- **IMontadorSql.** Lê os atributos da classe e gera `INSERT`, `UPDATE`, `DELETE` e `SELECT`, inclusive `INSERT ... RETURNING` e filtro `CONTAINING`.
- **ISettings.** Lê e grava o arquivo `conf.ini`.

Os setters das entidades retornam a própria interface (`Result := Self`), então a montagem do objeto pode ser encadeada:

```pascal
TCliente.New
  .SetNome('Maria Silva')
  .SetCEP('01001000');
```

### Atributos de mapeamento

Definidos em `src/utils/utils.uAtributos.pas` e aplicados aos campos privados das classes de modelo:

| Atributo | Papel |
| --- | --- |
| `Tabela('NOME')` | Nome da tabela no banco. |
| `Campo('NOME')` | Nome da coluna. Só campos com esse atributo entram no SQL. |
| `PK` | Chave primária. Entra no `WHERE` de atualização e exclusão e não entra no `SET` do `UPDATE`. |
| `Identidade` | Coluna gerada pelo banco. É omitida no `INSERT` quando o valor ainda é zero ou negativo, e é preenchida depois pelo valor retornado. |
| `Relacionamento(TClasse)` | Indica a classe da entidade relacionada. `IDao.Relacionado` cria essa instância e carrega a chave. |

Exemplo no pedido: `CODIGO_CLIENTE` aponta para `TCliente`, e no item `CODIGO_PRODUTO` aponta para `TProduto`.

## Estrutura do projeto

```
ORM_Gerenciador_Pedido/
    CadastroPedido.dpr          programa principal
    CadastroPedido.dproj        projeto Delphi
    readme.md
    database/
       init.sql                cria o banco do zero (apaga as tabelas existentes)
       alter_estoque.sql       adiciona PRODUTO.ESTOQUE em base já existente
       conf.ini                modelo de conexão (não colocar senha no repositório)
    src/
        View/                   Principal, Cliente, Produto, Pedido, Pesquisa
        Controller/             TController e controladores de cliente, produto, pedido e CEP
        Model/
           cliente/            ICliente, TCliente
           produto/            IProduto, TProduto
           pedido/             IPedido, TPedido
           pedidoItens/        IItensPedido, TPedidoItens
           entity/             IEntity, TEntity
           DAO/                IDao, TDao
           conexao/            IConnection, FireDAC, IQuery, ISettings
           CEP/                IViaCEP, TViaCEP
           validacao/          EValidacao
           totalizador/       soma TOTAL_ITEM do dataset de itens
        utils/                  atributos, montador de SQL, mapeador, RTTI e utilitários
```

A tela principal (`TFPrincipal`) abre Cliente, Produto e Pedido em modo modal. O menu lateral pode ficar recolhido (só ícones, com dica) ou expandido (rótulos).

## Modelo de dados

O script `database/init.sql` é específico de Firebird. Ele remove triggers, tabelas e generators se já existirem e recria o esquema. **Executá-lo de novo apaga os dados.**

Em uma base que já existe e só falta a coluna de estoque, use `database/alter_estoque.sql`. Esse script adiciona `PRODUTO.ESTOQUE` somente quando a coluna ainda não está presente.

### CLIENTE

| Coluna | Tipo | Observação |
| --- | --- | --- |
| CODIGO | INTEGER | Chave primária. Generator `GEN_CLIENTE_ID`, trigger `TRG_CLIENTE_BI`. |
| NOME | VARCHAR(100) | Obrigatório na aplicação. |
| CEP | VARCHAR(8) | Obrigatório. A consulta ViaCEP espera 8 dígitos. |
| LOGRADOURO | VARCHAR(100) | Obrigatório. |
| COMPLEMENTO | VARCHAR(50) | Opcional. |
| BAIRRO | VARCHAR(50) | Obrigatório. |
| CIDADE | VARCHAR(50) | Obrigatório. |
| UF | CHAR(2) | Obrigatório. |
| CODIGO_IBGE | VARCHAR(10) | Obrigatório. Preenchido pela ViaCEP. |

### PRODUTO

| Coluna | Tipo | Observação |
| --- | --- | --- |
| CODIGO | INTEGER | Chave primária. Generator `GEN_PRODUTO_ID`, trigger `TRG_PRODUTO_BI`. |
| DESCRICAO | VARCHAR(100) | Obrigatória. |
| VALOR_UNITARIO | DECIMAL(15,2) | Obrigatório e maior que zero. |
| ESTOQUE | DECIMAL(15,4) | Padrão 0. Movimentado pelos pedidos. |

### PEDIDO

| Coluna | Tipo | Observação |
| --- | --- | --- |
| CODIGO | INTEGER | Chave primária. Generator `GEN_PEDIDO_ID`, trigger `TRG_PEDIDO_BI`. |
| REFERENCIA | VARCHAR(50) | Obrigatória. |
| NUMERO_PEDIDO | VARCHAR(20) | Obrigatório e único (`UNQ_PEDIDO_NUMERO`). |
| DATA_EMISSAO | DATE | Obrigatória. |
| CODIGO_CLIENTE | INTEGER | Chave estrangeira para `CLIENTE`. |
| TIPO_OPERACAO | VARCHAR(10) | `E` (entrada) ou `S` (saída). |
| TOTAL_PEDIDO | DECIMAL(15,2) | Soma dos totais dos itens. |

### ITENS_PEDIDO

| Coluna | Tipo | Observação |
| --- | --- | --- |
| CODIGO | INTEGER | Sequencial por pedido. A trigger `TRG_ITENS_PEDIDO_BI` atribui `MAX(CODIGO) + 1` do mesmo pedido quando o código vem nulo ou zero. |
| CODIGO_PEDIDO | INTEGER | Chave estrangeira para `PEDIDO`. Faz parte da chave primária junto com `CODIGO`. |
| CODIGO_PRODUTO | INTEGER | Chave estrangeira para `PRODUTO`. |
| QUANTIDADE | DECIMAL(15,4) | Maior que zero. |
| VALOR_UNITARIO | DECIMAL(15,2) | Maior que zero. |
| TOTAL_ITEM | DECIMAL(15,2) | Quantidade multiplicada pelo valor unitário. |

## Regras de negócio

### Cliente

Campos obrigatórios: nome, CEP, logradouro, bairro, cidade, UF e código IBGE. O complemento pode ficar em branco. A exclusão é recusada quando existe pedido com aquele `CODIGO_CLIENTE`.

### Produto

Descrição obrigatória e valor unitário maior que zero. Na alteração, o controller relê o estoque gravado e o mantém: o cadastro de produto não sobrescreve a quantidade em estoque. A exclusão é recusada quando o produto aparece em `ITENS_PEDIDO`.

### Pedido e estoque

Antes de gravar, o pedido valida o cabeçalho e exige ao menos um item. Cada item precisa de produto, quantidade maior que zero e valor unitário maior que zero. O total do item é recalculado e o total do pedido é a soma desses totais.

A gravação e a exclusão do pedido ocorrem em uma única transação FireDAC. Se qualquer passo falhar, a transação é cancelada.

Movimentação de `PRODUTO.ESTOQUE`:

- **Entrada (`E`)** soma a quantidade.
- **Saída (`S`)** subtrai a quantidade.
- **Alteração** estorna os itens que já estavam gravados e aplica de novo os itens da tela.
- **Exclusão** estorna os itens, apaga os itens do pedido e depois apaga o cabeçalho.
- Itens removidos na edição são excluídos e o estorno da movimentação anterior já foi feito no início da alteração.
- Se a operação deixaria o estoque negativo, a gravação é interrompida com a mensagem de estoque insuficiente.

## Persistência

`TDao` recebe a entidade (como `IInterface`) e, se nenhuma conexão for informada, abre uma pelo pool FireDAC. O fluxo de uma inclusão é:

1. `TMontadorSql` percorre os campos com `[Campo]` e monta o `INSERT`, ignorando a identidade ainda sem valor.
2. Os valores vão para um dicionário de parâmetros.
3. `IQuery` executa o comando na conexão.
4. Quando a identidade precisa voltar do banco, o DAO usa `INSERT ... RETURNING` e `TMapeador.AtribuirIdentidade` grava o código no objeto.

`Materializar` faz o caminho inverso: lê o dataset da última consulta e preenche as propriedades marcadas com `[Campo]`.

A conexão usa um pool chamado `PEDIDO_POOL`, criado na primeira abertura a partir de `conf.ini`, na pasta do executável (`ExtractFilePath(ParamStr(0))`). `LoginPrompt` fica desligado.

## Como executar

### Pré-requisitos

- Delphi 10.3 Rio, com VCL e FireDAC (driver Firebird).
- Firebird instalado e acessível (servidor local ou remoto).
- Acesso à internet na máquina que for consultar CEP.

### Banco

1. Crie um arquivo `.fdb` vazio no Firebird (por exemplo `PEDIDO.FDB`).
2. Execute `database/init.sql` nesse banco, no IBExpert, isql, FlameRobin ou ferramenta equivalente.
3. Se a base já foi criada por uma versão anterior do script, sem a coluna `ESTOQUE`, execute apenas `database/alter_estoque.sql`.

### Configuração

Copie `database/conf.ini` para a pasta do executável (em depuração, a pasta de saída do Delphi, em geral `Win32/Debug`) e ajuste os valores:

```ini
[CONFIG]
DRIVERNAME=FB
CAMINHO=C:\caminho\para\PEDIDO.FDB
USUARIO=SYSDBA
SERVIDOR=localhost
PORTA=3050
SENHA=
```

| Chave | Significado |
| --- | --- |
| DRIVERNAME | Identificador do driver FireDAC. Para Firebird, `FB`. |
| CAMINHO | Caminho do arquivo `.fdb`. |
| USUARIO | Usuário do banco. |
| SENHA | Senha do usuário. Preencha só na máquina local. |
| SERVIDOR | Host do Firebird. Se informado, a conexão usa protocolo TCP/IP e a porta. |
| PORTA | Porta do Firebird. O padrão do servidor é `3050`. |

O arquivo de exemplo no repositório deixa `SENHA` vazia de propósito. Não grave senha real no controle de versão.

### Compilação

1. Abra `CadastroPedido.dpr` (ou `CadastroPedido.dproj`) no Delphi.
2. Confirme que `conf.ini` está na pasta onde o executável será gerado.
3. Compile e execute (F9).

Atalho de obtenção do código, se o repositório remoto for usado:

```
git clone https://github.com/MarceloFormentini/GerenciadorPedido.git
```

## Fluxo de uso

1. Cadastre os clientes. No CEP, use a consulta para preencher logradouro, bairro, cidade, UF e IBGE.
2. Cadastre os produtos com descrição e valor unitário. O estoque inicial é zero.
3. Abra Pedidos, informe o cabeçalho, escolha o cliente e inclua os itens. Entrada aumenta o estoque; saída diminui.
4. Salve. O número do pedido não pode repetir um número já gravado.
5. Para corrigir, pesquise o pedido, altere os itens e salve de novo. A movimentação de estoque anterior é estornada antes da nova.

## Tratamento de validação

`EValidacao` (`src/Model/validacao/model.validacao.uValidacao.pas`) carrega o nome do campo e a mensagem. As telas de cliente, produto e pedido capturam essa exceção e posicionam o foco no controle ligado ao campo (`NOME`, `CEP`, `DESCRICAO`, `NUMERO_PEDIDO`, `ESTOQUE`, entre outros). As demais falhas, como CEP inexistente ou erro de conexão, seguem como exceção comum e são exibidas em mensagem.

Mensagens frequentes:

- campo obrigatório de cliente, produto, cabeçalho ou item;
- pedido sem itens;
- tipo de operação diferente de entrada ou saída;
- cliente ou produto vinculado a pedido, na exclusão;
- estoque insuficiente na saída (ou na troca de uma entrada já gravada);
- CEP inválido ou indisponível na consulta ViaCEP.
