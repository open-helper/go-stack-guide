# ####################################
# @file: Makefile
# @name: micro-service
# @date: 2019-12-18 12:34:43
# @tver: 20191217
# ####################################


DK      := docker
DC      := docker-compose
DK_EXEC := docker exec -it

DATA_SUF:= $(shell date +"%Y.%m.%d.%H.%M.%S")


# ####################################
# Dashboard AREA
# ####################################
up: start-sv
down: stop-sv
status: status-sv
ctl: ctl-sv
demo: start-client

start-client:
	micro call greeter Greeter.Hello '{"name": "Micro中国"}'
	go run service/client.go
	go test service/hello_test.go
start-timeout-client:
	go run timeout/client.go


# ####################################
# supervisor 托管区域
# ####################################
start-server-by-func-fg:
	go run function/main.go
start-server-by-service-fg:
	go run service/server.go
start-stream-file-server-fg:
	go run stream/file/server.go
start-stream-file-web-fg:
	go run stream/file/client.go
start-timeout-server-fg:
	go run timeout/server.go


# ####################################
# supervisor AREA
# ####################################
start-sv: init-sv
	supervisord -c ./supervisord.conf
stop-sv:
	supervisorctl -c ./supervisord.conf stop all
	supervisorctl -c ./supervisord.conf shutdown
status-sv:
	supervisorctl -c ./supervisord.conf status
ctl-sv:
	supervisorctl -c ./supervisord.conf
init-sv:
	[ -d /tmp/go-stack-guide ] || mkdir -p /tmp/go-stack-guide


# ####################################
# Utils AREA
# ####################################
clean:
	rm -rvf *.bak *.log
	-$(DK) ps -a | grep Exited | awk '{print $$1}' | xargs $(DK) rm
	-$(DK) images | grep "^<none>" | awk '{print $$3}' | xargs $(DK) rmi
