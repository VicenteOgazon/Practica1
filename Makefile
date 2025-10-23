#Docker
restart:
	sudo systemctl restart docker

start:
	sudo docker start $(c)

stop:
	sudo docker stop $(c)
ps:
	sudo docker ps 

#Production docker compose Makefile
DOCKER_COMPOSE_PROD = prod_env/docker-compose.prod.yml
up-prod:
	sudo docker compose -f $(DOCKER_COMPOSE_PROD) up -d
stop-prod:
	sudo docker compose -f $(DOCKER_COMPOSE_PROD) stop
down-prod:
	sudo docker compose -f $(DOCKER_COMPOSE_PROD) down
build-prod:
	sudo docker build --no-cache -f prod_env/Dockerfile -t app:prod .
logs-prod:
	sudo docker compose -f $(DOCKER_COMPOSE_PROD) logs -f
ps-prod:
	sudo docker compose -f $(DOCKER_COMPOSE_PROD) ps
restart-prod:
	sudo docker compose -f $(DOCKER_COMPOSE_PROD) restart
clean-prod:
	sudo docker compose -f $(DOCKER_COMPOSE_PROD) down -v
	sudo docker system prune -f


#Development docker compose Makefile
DOCKER_COMPOSE_DEV = dev_env/docker-compose.dev.yml
up-dev:
	sudo docker compose -f $(DOCKER_COMPOSE_DEV) up -d
stop-dev:
	sudo docker compose -f $(DOCKER_COMPOSE_DEV) stop
down-dev:
	sudo docker compose -f $(DOCKER_COMPOSE_DEV) down
build-dev:
	sudo docker build --no-cache -f dev_env/Dockerfile -t app:dev .
logs-dev:
	sudo docker compose -f $(DOCKER_COMPOSE_DEV) logs -f
ps-dev:
	sudo docker compose -f $(DOCKER_COMPOSE_DEV) ps
restart-dev:
	sudo docker compose -f $(DOCKER_COMPOSE_DEV) restart
clean-dev:
	sudo docker compose -f $(DOCKER_COMPOSE_DEV) down -v
	sudo docker system prune -f

help:
	@echo ""
	@echo "Comandos disponibles:"
	@echo "  make restart						- Reinicia el servicio de Docker"
	@echo "  make start c=CONTAINER ID			- Inicia un contenedor especificado"
	@echo "  make stop c=CONTAINER ID			- Para un contenedor especificado"
	@echo "  make ps							- Muestra todos los contenedores en ejecución"
	@echo "  make up-dev						- Levanta el entorno de desarrollo"
	@echo "  make down-dev						- Detiene y elimina los contenedores de desarrollo"
	@echo "  make build-prod					- Construye la imagen de producción"
	@echo "  make up-prod						- Levanta el entorno de producción"
	@echo "  make clean-prod					- Limpia contenedores y caché de Docker"
	@echo "  make ps-dev						- Muestra el estado de los contenedores dev"
	@echo "  make ps-prod						- Muestra el estado de los contenedores prod"
	@echo ""