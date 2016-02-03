
build:
	docker build -t irc .

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
	docker rm $(docker ps -a -q)
	docker rmi $(docker images | grep "^<none>" | awk "{print $3}")

.PHONY: build run enter bash clean

