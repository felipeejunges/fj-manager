Seja bem-vindo a mais uma etapa do processo de seleção da Monde. Neste etapa você precisa desenvolver este pequeno projeto. Leia com atenção e **em caso de dúvidas crie issues neste repositório**.

# Prazo
- 14 dias corridos.

# Problema
- Nós precisamos suportar vários meios de pagamento para receber de nossos clientes. Eles podem pagar por boleto, por cartão de crédito, por depósito e amanhã podem surgir novas formas como Pix.
- Cada cliente pode escolher como quer fazer o pagamento. Essa escolha deve ficar registrada no sistema e levada em consideração toda vez que um faturamento for gerado para o cliente.
- O faturamento deverá ser executado uma vez por mês no dia de vencimento escolhido pelo cliente e utilizar a forma de pagamento escolhida por ele.

# Requisitos
- CRUD de clientes onde posso selecionar a forma de pagamento de cada cliente. As formas de pagamento devem ser carregadas dinamicamente sem que o CRUD conheça as formas disponíveis.
- O processo de faturamento não pode "conhecer" os métodos de pagamento disponíveis, ele deve tratar todos de forma genérica.
- Esse é o requisito mais importante do projeto: Para adicionar ou remover novas formas de pagamento, não é permitido modificar nenhum código do app, apenas remover ou adicionar novas classes. 
- O processo de faturamento deverá faturar diariamente os clientes com vencimento no dia. Para este exemplo basta gerar um log ou algum relatório informando quais clientes foram faturados e qual a forma de pagamento de cada um.
- O processo de faturamento deverá ter garantias de que o mesmo cliente não será faturado mais de uma vez dentro do mesmo mês e em caso de erros (sistema de pagamento indisponível por exemplo), deverá logar o erro ou gerar um relatório e fazer novas tentativas automaticamente.

# Como e o que codificar
- Utilize apenas este repositório para todo o desenvolvimento e entrega do projeto.
- Faça os commits diretamente na branch `main` ou envie Pull Requests e faça o merge nessa branch se preferir.
- Entregue um app funcionando e com testes (RSpec ou Minitest)
- Utilize SQLite para o banco de dados e migrations/schema do Rails para a estrutura.
- Implemente o projeto usando todas as melhores práticas que você conhecer. TDD, CI, etc.
- Diagramas são opcionais, mas se fizer algum, entregue pois temos interesse.
- Nenhum tipo de integração verdadeira é necessário. Quando as classes de pagamento forem chamadas, você pode apenas registrar uma mensagem no console, por exemplo: "Boleto emitido" ou "Cartão debitado".

# O que será avaliado?
- Testes automatizados
  - Iremos executar os testes localmente, tenha certeza que eles estão passando antes de entregar o projeto.
  - Se o projeto não tiver testes ou estiverem em branco ou falhando, não avaliaremos os demais requisitos.
- Simplicidade, clareza e estilo do código
- Arquitetura do código
- Facilidade de plugar novas formas de pagamento
- UI e UX do aplicativo de exemplo
  - Iremos executar o app localmente e verificar se ele funciona como deveria e se é intuitivo.

Não é necessário utilizar um framework para o front-end e nem criar cadastro e autenticação de usuários, consideraremos como bônus se fizer autenticação e/ou fizer um layout responsivo usando Bootstrap.

# Isso é apenas um teste
- Apesar de ser um problema aparentemente real de um sistema de faturamento, ele foi escrito apenas para teste. Seu código não será usado depois que o teste for finalizado.
