

PROJECT:=$(shell basename $$(pwd))
VERSION:=$(shell cat VERSION)
REPO:=rstms/${PROJECT}
URL:=https://github.com/${REPO}
SSH_KEY := $(if ${SSH_KEY},${SSH_KEY},${HOME}/.ssh/id_rsa.pub)

.PHONY: test build bash ssh run clean

test:
	@echo ${SSH_KEY}

build: motd 
	env SSH_KEY="$$(base64 -w0 <${SSH_KEY})" DOCKER_TAG=${VERSION} DOCKER_REPO=${REPO} packer build ${PROJECT}.json

motd: VERSION
	/bin/echo -e "$$(figlet -w 135 ${PROJECT})\nVersion ${VERSION}\n${URL}\n" >motd
	@cat motd

bash:
	docker exec -it ${PROJECT} bash -l

ssh:
	@ssh -i ${SSH_KEY} -p $$(docker port ${PROJECT}| awk -F: '{print $$2}') alpine@localhost

start:
	docker run -P --rm --privileged=true --name=${PROJECT} ${REPO}:${VERSION}&

stop:
	docker rm -f ${PROJECT}

clean:
	@echo Cleaning up docker environment...
	@docker ps -aq | xargs -ICID -n 1 docker rm -f CID
	@docker images -aq | xargs -ICID -n 1 docker rmi -f CID
