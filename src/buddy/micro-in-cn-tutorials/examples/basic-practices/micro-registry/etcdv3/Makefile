
# ####################################
# etcdv3 AREA
# ####################################


# ####################################
# Dashboard AREA
# ####################################
up: start-sv
down: stop-sv
status: status-sv
ctl: ctl-sv
demo: start-client

start-client:
	go run client.go plugins.go --registry=etcdv3 --registry_address=127.0.0.1:12379


# ####################################
# supervisor 托管区域
# ####################################
start-etcd-fg:
	etcd --debug  --name=default --data-dir=/tmp/default.etcd --listen-client-urls http://0.0.0.0:12379 --advertise-client-urls http://0.0.0.0:12380
start-server-fg:
	go run server.go plugins.go --registry=etcdv3 --registry_address=127.0.0.1:12379


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
