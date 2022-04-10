dev_arch := $(shell uname -p)
include .env

VARS:=$(shell sed -ne 's/ *\#.*$$//; /./ s/=.*$$// p' .env )
$(foreach v,$(VARS),$(eval $(shell echo export $(v)="$($(v))")))


clean:
	docker-compose down
	rm -rf mongo
setup:
	docker run -it --rm -v $(PWD)/${APP_DIR}:/app -w /app node:fermium-buster npx create-react-app ../app
	docker run -it --rm -v $(PWD)/${API_DIR}:/app -w /app node:fermium-buster npx express-generator ../app
install:
	docker run -it --rm -v $(PWD)/${APP_DIR}:/app -w /app node:fermium-buster yarn install
	docker run -it --rm -v $(PWD)/${API_DIR}:/app -w /app node:fermium-buster yarn install
install-on-app:
	docker run -it --rm -v $(PWD)/${APP_DIR}:/app/ -w /app node:fermium-buster yarn add $(MODULE)
install-on-api:
	docker run -it --rm -v $(PWD)/${API_DIR}:/app/ -w /app node:fermium-buster yarn add $(MODULE)
upgrade:
	docker run -it --rm -v ${APP_DIR}:/app/ -w /app node:fermium-buster yarn upgrade
restart:
	docker-compose down
	docker-compose --env-file .env up -d
stop:
	docker-compose down
start:
	docker-compose down
	docker-compose --env-file .env up -d
dev:
	docker-compose down
	docker-compose --env-file .env up
all:
	make stop
	make clean
	make setup
	make install
	make start

