# ####################################
# @file: Makefile
# @name: micro-config
# @date: 2019-12-18 13:02:54
# @tver: 20191217
# ####################################


DK      := docker
DC      := docker-compose
DK_EXEC := docker exec -it

DATA_SUF:= $(shell date +"%Y.%m.%d.%H.%M.%S")


# ####################################
# Dashboard AREA
# ####################################
up: start-client
down:
demo: start-client

start-client:
	go run main.go
