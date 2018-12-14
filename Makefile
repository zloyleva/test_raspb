container = webapp_docker

build: #build docker container #
	# @sudo docker build -t $(container) .  
	@sudo docker build --no-cache -t $(container) .  

stop: #stop docker container #
	@docker stop $(container)

connect: #show docker container #
	@docker exec -it $(container) bash

remove: #stop docker container #
	@docker rm -f $(container) 

show: #show docker container #
	@docker ps