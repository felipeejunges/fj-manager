
# FJ Manager
[![en](https://img.shields.io/badge/lang-en-red.svg)](https://github.com/felipeejunges/fj-manager/blob/main/README.md)
[![Docker CI](https://github.com/felipeejunges/fj-manager/actions/workflows/dockerci.yml/badge.svg?branch=main)](https://github.com/felipeejunges/fj-manager/actions/workflows/dockerci.yml?query=branch%3Amain)

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
- Simplecov
- Pagy
- Annotate
- GitActions for CI

## Instruções

Estas instruções abordará a inicialização do projeto e utilização do mesmo atráves do docker

- Rodar o comando `docker-compose build` para configurar o projeto
- Rodar o comando `docker-compose up` para inicializar o projeto
- Para rodar os testes, é precisar estar dentro do bash do docker ou de onde o projeto está rodando e utilizar o comando `rspec`
    - Os testes podem não rodar sem docker por depender do selenium, redis e sidekiq

## Apresentação do projeto
Link com vídeo da apresentação do projeto: https://www.loom.com/share/0599be79f6524f7ba1d232050f01ca7b

## Usuário Padrão
- email: master@email.com
- senha: 123

## Regras de Negócio

### Usuário
- Último usuário administrador não pode ser deletado
- Apenas usuários administradores podem criar novos, editar e deletar usuários
- Mesmo sendo usuário administrador, o usuário não pode se auto-deletar

### Clientes e Faturamento
- O faturamento ocorre todo dia as 01:00 para clientes com dia de pagamento no dia atual e que ainda não foram faturados no periodo do plano selecionado (gerados ou pagos)
- O faturamento pode ter alteração de forma de pagamento caso atinja 10 tentativas com erro na mesma forma de pagamento.

## Coverage

![coverage](https://private-user-images.githubusercontent.com/20795458/276079309-e607d813-97fc-404d-b57d-db678e95bd0b.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTEiLCJleHAiOjE2OTc2MDE2OTQsIm5iZiI6MTY5NzYwMTM5NCwicGF0aCI6Ii8yMDc5NTQ1OC8yNzYwNzkzMDktZTYwN2Q4MTMtOTdmYy00MDRkLWI1N2QtZGI2NzhlOTViZDBiLnBuZz9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFJV05KWUFYNENTVkVINTNBJTJGMjAyMzEwMTglMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjMxMDE4VDAzNTYzNFomWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPTQxNWFkNGU0OTZlZTdkZWVkNjZjNDYzOTlkNTMyNzE3OGQxNjA4ZDY2YjQ5ODU1NzIyM2JjYjUyNWFiMTdlYTgmWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0JmFjdG9yX2lkPTAma2V5X2lkPTAmcmVwb19pZD0wIn0.gjo1jZ48cIpgfq6-ZLEgvY9OAWjrD4wya37nLzxmf38)
