REGISTRY := $(shell cat .registry)
APP_NAME := $${PWD\#\#*/}

ifeq ($(strip $(version)),)
VERSION_TAG := latest
else
VERSION_TAG := $(version)
endif


IMAGE_TAG := ${REGISTRY}/${APP_NAME}:${VERSION_TAG}

init:
	mkdir test/conf

login:
	@doctl registry login

build: login
	@docker build . -t ${IMAGE_TAG}

push: build
	@docker push ${IMAGE_TAG}

start:
	@docker-compose build --no-cache
	@docker-compose up -d

stop:
	@docker-compose down --remove-orphans
	@docker-compose rm -s -f

secret:
	@kubectl -n plex create secret generic plex-credentials \
	--from-literal=s3-access-key=$${PLEX_S3_ACCESS_KEY} \
	--from-literal=s3-secret-key=$${PLEX_S3_SECRET_KEY} \
	--from-literal=claim-token=$${PLEX_CLAIM_TOKEN}


