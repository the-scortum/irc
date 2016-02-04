#!/bin/bash

build:
	docker build -t irc .

rebuild:
	docker build --no-cache -t irc . 

run:
	-docker stop irc
	-docker rm irc
	docker run -d --name irc \
           -v /etc/localtime:/etc/localtime:ro \
           -v ~/irc/src/tmp:/tmp \
           -p 6999:6999  \
           irc

enter:
	docker exec -it irc bash

bash:
	docker run -it --rm \
           -v /etc/localtime:/etc/localtime:ro \
           -v ~/irc/src/tmp:/tmp \
           -p 6999:6999  \
           irc bash




clean:
	$(eval STOPPED_CONTAINER := $(shell docker ps -a -q))
	@echo $(STOPPED_CONTAINERS)
	$(STOPPED_CONTAINERS): docker rm $@
	$(eval DANGLING_IMAGES := $(shell docker images -f "dangling=true" -q))
	@echo $(DANGLING_IMAGES)
	$(DANGLING_IMAGES): docker rmi $@

# http://www.projectatomic.io/blog/2015/07/what-are-docker-none-none-images/

.PHONY: build run enter bash clean

