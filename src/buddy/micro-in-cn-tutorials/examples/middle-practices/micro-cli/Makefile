# ####################################
# @file: Makefile
# @name: ~/devhome/go-stack-guide/src/buddy/micro-in-cn-tutorials/examples/middle-practices/micro-cli
# @date: 2019-12-19 14:32:14
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



# ####################################
# 命令行参数处理
# ####################################
run: run-no-args run-with-args
run-no-args:
	go run flags/main.go
run-with-args:
	go run flags/main.go --int_flag 1234 --bool_flag --string_flag "ABC"
	go run flags/main.go --int_flag 1234 --bool_flag --string_flag "ABC" --string_flag_default xyz


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
