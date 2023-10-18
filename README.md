
# FJ Manager
[![pt-br](https://img.shields.io/badge/lang-pt--br-green.svg)](https://github.com/felipeejunges/fj-manager/blob/main/README.pt-br.md)
[![Docker CI](https://github.com/felipeejunges/fj-manager/actions/workflows/dockerci.yml/badge.svg?branch=main)](https://github.com/felipeejunges/fj-manager/actions/workflows/dockerci.yml?query=branch%3Amain)

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
- Simplecov
- Pagy
- Annotate
- GitActions for CI

## Instructions

This instructions shows how to initialize the project and using it with [docker](https://docs.docker.com/engine/install/ubuntu/)

- Run command `docker-compose build` to configure the project
- Run command `docker-compose up` to initialize the project
- You can run tests, to do this, you have to be inside docker bash container with command `rspec`
    - Specs may not working correctly without docker, as it depends on sidekiq, redis and selenium

## Project presentation
Link with project presentation: https://www.loom.com/share/0599be79f6524f7ba1d232050f01ca7b

## Default user
- email: master@email.com
- password: 123

## Business Rules

### User
- The last admin user can't be deleted
- Only admin users can create new, edit or delete users
- Even user being admin, can't auto-delete itself

### Clientes e Faturamento
- The invoice happens every day at 1AM for clients with payment day the current day that didn't get invoiced yet on the billable period from plan.
- The invoice can have changes on payment type, if it hits 10 try's with error on same payment type.

## Coverage

![coverage](https://private-user-images.githubusercontent.com/20795458/276079309-e607d813-97fc-404d-b57d-db678e95bd0b.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTEiLCJleHAiOjE2OTc2MDE2OTQsIm5iZiI6MTY5NzYwMTM5NCwicGF0aCI6Ii8yMDc5NTQ1OC8yNzYwNzkzMDktZTYwN2Q4MTMtOTdmYy00MDRkLWI1N2QtZGI2NzhlOTViZDBiLnBuZz9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFJV05KWUFYNENTVkVINTNBJTJGMjAyMzEwMTglMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjMxMDE4VDAzNTYzNFomWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPTQxNWFkNGU0OTZlZTdkZWVkNjZjNDYzOTlkNTMyNzE3OGQxNjA4ZDY2YjQ5ODU1NzIyM2JjYjUyNWFiMTdlYTgmWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0JmFjdG9yX2lkPTAma2V5X2lkPTAmcmVwb19pZD0wIn0.gjo1jZ48cIpgfq6-ZLEgvY9OAWjrD4wya37nLzxmf38)
