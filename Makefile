
build:
	docker-compose build

install:
	docker-compose run server bundle install

create-database:
	docker-compose run server rake db:create

migrate:
	docker-compose run server rake db:migrate

rollback_one_step:
		docker-compose run server rake db:rollback STEP=1

seed:
	docker-compose run server rake db:seed

down-database:
	docker-compose run server rake db:drop

down-database-dev:
	docker-compose run server rake RAILS_ENV=development db:drop

build-db:
	make create-database migrate seed

set_env:
	docker compose run server bin/setup db:environment:set RAILS_ENV=development

setup:
	make build install build-db

down-rmi:
	docker-compose down && docker rmi scratch_server_server --force

rmi-postgres:
	docker rmi postgres --force

down-all:
	make down-database-dev down-rmi

reset:
	make down-all setup

reset-db:
	make down-database-dev build-db

up:
	docker-compose up

console:
	docker-compose exec server bundle exec rails c

bash:
	docker-compose exec server bash

tests:
	docker-compose exec server bundle exec rspec spec

rubocop:
	docker-compose exec server bundle exec rubocop

diagram_all:
	docker-compose exec server rake diagram:all

server-clean:
	docker-compose down

restore-permission:
	sudo chown -R $USER:$USER .