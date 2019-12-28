alpine-daemontools
------------------

A multiservice docker container based on alpine for running daemontools supervised services.

Initialized with openssh, user alpine, supporting only public key authentication.

== Introduction

This project aims to build a minimal environment for daemontools supervised procesess.  It uses
alpine as a base, and runs svscanboot as process 1.   There is no traditional init system.  Instead,
first-boot configuration is done using an ansible playbook `bootstrap.yml`.  Hashicorp [Packer](https://packer.io)
is used to build the image and upload it to docker hub.


== SSH Authentication:

The system runs a supervised sshd, configured for public key authentication.  A private key in openssh
format may be provided at build time using the environment variable PUBLIC_KEY=<FILENAME> with the defaut of `~/.ssh/id_rsa.pub`


== CLI

Make is used to control the process.  The following make targets are defined:

`make [PUBLIC_KEY=<FILENAME>] build` - builds a new image

`make start` - starts the container with `docker run`

`make [PRIVATE_KEY=<FILENAME>] ssh` - builds an ssh command line and connects to the running container

`make stop` - stops the container started by `make start`

`make clean` - stops ALL docker containers in the system and removes ALL local docker images
