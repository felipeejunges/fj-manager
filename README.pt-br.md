
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

### Driagrama base/inicio
![Diagrama](https://private-user-images.githubusercontent.com/20795458/273672967-071e6706-afa7-45cf-8521-2eecb03e126f.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTEiLCJleHAiOjE2OTY4Nzc4NDAsIm5iZiI6MTY5Njg3NzU0MCwicGF0aCI6Ii8yMDc5NTQ1OC8yNzM2NzI5NjctMDcxZTY3MDYtYWZhNy00NWNmLTg1MjEtMmVlY2IwM2UxMjZmLnBuZz9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFJV05KWUFYNENTVkVINTNBJTJGMjAyMzEwMDklMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjMxMDA5VDE4NTIyMFomWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPWZhOWQyN2U3N2Y5MGZlYWI2N2I4OTAwMjU4MTBmMDU4MTAxYzUzZGIxMmIxODZlZmQ3ZTUwNmNlZTk2ZmUzY2UmWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0JmFjdG9yX2lkPTAma2V5X2lkPTAmcmVwb19pZD0wIn0.MjqkgaxLiC4qZ8ibb2xdgr5WBGsby7TwyaaTwz_erx0)

***
###### [readme antigo](https://github.com/felipeejunges/fj-manager/blob/3bdec39ac9eebabe06a83fb53418ff42e62ccdbf/README.md)