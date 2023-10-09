
# Felipe Ruby Test
[![pt-br](https://img.shields.io/badge/lang-pt--br-green.svg)](https://github.com/monde-testes/teste-ruby-felipe/blob/main/README.md)
[![Docker CI](https://github.com/monde-testes/teste-ruby-felipe/actions/workflows/dockerci.yml/badge.svg?branch=main)](https://github.com/monde-testes/teste-ruby-felipe/actions/workflows/dockerci.yml?query=branch%3Amain)

This project is a client-invoice manager.

## Technologies

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

## Instructions

This instructions shows how to initialize the project and using it with [docker](https://docs.docker.com/engine/install/ubuntu/)

- Run command `docker-compose build` to configure the project
- Run command `docker-compose up` to initialize the project
- You can run tests, to do this, you have to be inside docker bash container with command `rspec`
    - Specs may not working correctly without docker, as it depends on sidekiq, redis and selenium

## Project presentation
Link with project presentation: https://www.loom.com/share/b98d97c256e14a1393a826696c25a636

## Default user
- email: master@email.com
- password: 123

## Business Rules

### User
- The last admin user can't be deleted
- Only admin users can create new, edit or delete users
- Even user being admin, can't auto-delete itself

### Clientes e Faturamento
- The invoice happens every day at 1AM for clients with payment day for 1 day ago that didn't get invoiced yet.
- The invoice can have changes on payment type, if it hits 10 try's with error on same payment type.

### Driagrama base/inicio


***
###### [Old readme](https://github.com/monde-testes/teste-ruby-felipe/blob/3bdec39ac9eebabe06a83fb53418ff42e62ccdbf/README.md)