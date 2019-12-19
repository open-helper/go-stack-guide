# ####################################
# @file: Makefile
# @name: ~/devhome/go-stack-guide/src/buddy/micro-in-cn-tutorials/examples/middle-practices/micro-client
# @date: 2019-12-19 14:47:06
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
	echo it works.

run: run-json-client run-retry-client
run-json-client:
	go run json/main.go
run-retry-client:
	go run retry/client.go


# ####################################
# supervisor 托管区域
# ####################################
start-rpc-server:
	go run rpc/rpc.go
start-retry-failure-server:
	go run retry/FailureServer.go
start-retry-success-server:
	go run retry/SuccessServer.go


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
