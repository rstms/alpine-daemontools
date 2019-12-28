

PROJECT:=$(shell basename $$(pwd))
VERSION:=$(shell cat VERSION)
REPO:=rstms/${PROJECT}
URL:=https://github.com/${REPO}
PUBLIC_KEY := $(if ${PUBLIC_KEY},${PUBLIC_KEY},${HOME}/.ssh/id_rsa.pub)
PRIVATE_KEY := $(if ${PRIVATE_KEY},${PRIVATE_KEY},${HOME}/.ssh/id_rsa)

.PHONY: test build bash ssh run clean

build: motd 
	env SSH_KEY="$$(base64 -w0 <${PUBLIC_KEY})" DOCKER_TAG=${VERSION} DOCKER_REPO=${REPO} packer build ${PROJECT}.json

motd: VERSION
	/bin/echo -e "$$(figlet -w 135 ${PROJECT})\nVersion ${VERSION}\n${URL}\n" >motd
	@cat motd

bash:
	docker exec -it ${PROJECT} bash -l

ssh:
	@ssh -i ${PRIVATE_KEY} -p $$(docker port ${PROJECT}| awk -F: '{print $$2}') alpine@localhost

start:
	docker run -P --rm --privileged=true --name=${PROJECT} ${REPO}:${VERSION}&

stop:
	docker rm -f ${PROJECT}

clean:
	@echo Cleaning up docker environment...
	@docker ps -aq | xargs -ICID -n 1 docker rm -f CID
	@docker images -aq | xargs -ICID -n 1 docker rmi -f CID
