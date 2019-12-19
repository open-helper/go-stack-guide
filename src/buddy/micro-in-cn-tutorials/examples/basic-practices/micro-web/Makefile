# ####################################
# @file: Makefile
# @name: examples/basic-practices/micro-web
# @date: 2019-12-19 12:17:35
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

start-client: run-test
	echo it works.

log:
	supervisorctl -c ./supervisord.conf tail web-pub
	supervisorctl -c ./supervisord.conf tail web-sub


run-test:
	curl 'http://127.0.0.1:8088/hi?name=Just-do-it'


# ####################################
# supervisor 托管区域
# ####################################
start-web-pub:
	go run web-pub/main.go
start-web-sub:
	go run web-pub/sub.go


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
