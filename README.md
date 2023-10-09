
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

### Basic diagram
![Diagram](https://private-user-images.githubusercontent.com/20795458/273672967-071e6706-afa7-45cf-8521-2eecb03e126f.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTEiLCJleHAiOjE2OTY4Nzc4NDAsIm5iZiI6MTY5Njg3NzU0MCwicGF0aCI6Ii8yMDc5NTQ1OC8yNzM2NzI5NjctMDcxZTY3MDYtYWZhNy00NWNmLTg1MjEtMmVlY2IwM2UxMjZmLnBuZz9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFJV05KWUFYNENTVkVINTNBJTJGMjAyMzEwMDklMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjMxMDA5VDE4NTIyMFomWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPWZhOWQyN2U3N2Y5MGZlYWI2N2I4OTAwMjU4MTBmMDU4MTAxYzUzZGIxMmIxODZlZmQ3ZTUwNmNlZTk2ZmUzY2UmWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0JmFjdG9yX2lkPTAma2V5X2lkPTAmcmVwb19pZD0wIn0.MjqkgaxLiC4qZ8ibb2xdgr5WBGsby7TwyaaTwz_erx0)
