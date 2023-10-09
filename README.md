
# Teste Ruby Felipe
[![en](https://img.shields.io/badge/lang-en-red.svg)](https://github.com/monde-testes/teste-ruby-felipe/blob/main/README.en.md)
[![Docker CI](https://github.com/monde-testes/teste-ruby-felipe/actions/workflows/dockerci.yml/badge.svg?branch=main)](https://github.com/monde-testes/teste-ruby-felipe/actions/workflows/dockerci.yml?query=branch%3Amain)

Este é o projeto de gerenciamento de cliente-faturamento;

## Tecnologias

- Ruby v3.2.1
- Ruby on Rails v7.0.4
- Bootstrap 5
- SQLite3
- Docker
- Sidekiq
- Rspec
- FactoryBot
- Faker
- Selenium
- Capybara
- GitActions for CI

## Instruções

Estas instruções abordará a inicialização do projeto e utilização do mesmo atráves do docker

- Rodar o comando `docker-compose build` para configurar o projeto
- Rodar o comando `docker-compose up` para inicializar o projeto
- Para rodar os testes, é precisar estar dentro do bash do docker ou de onde o projeto está rodando e utilizar o comando `rspec`
    - Os testes podem não rodar sem docker por depender do selenium, redis e sidekiq

## Apresentação do projeto
Link com vídeo da apresentação do projeto: https://www.loom.com/share/b98d97c256e14a1393a826696c25a636

## Usuário Padrão
- email: master@email.com
- senha: 123

## Regras de Negócio

### Usuário
- Último usuário administrador não pode ser deletado
- Apenas usuários administradores podem criar novos, editar e deletar usuários
- Mesmo sendo usuário administrador, o usuário não pode se auto-deletar

### Clientes e Faturamento
- O faturamento ocorre todo dia as 01:00 para clientes com dia de pagamento de ontem e que ainda não foram faturados no mês (gerados ou pagos)
- O faturamento pode ter alteração de forma de pagamento caso atinja 10 tentativas com erro na mesma forma de pagamento.

***
###### [readme antigo](https://github.com/monde-testes/teste-ruby-felipe/blob/3bdec39ac9eebabe06a83fb53418ff42e62ccdbf/README.md)