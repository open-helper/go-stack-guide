
# ####################################
# etcdv3 AREA
# ####################################


# ####################################
# Dashboard AREA
# ####################################
start-etcd:
	etcd --debug  --name=default --data-dir=/tmp/default.etcd --listen-client-urls http://0.0.0.0:12379 --advertise-client-urls http://0.0.0.0:12380

start-server:	
	go run server.go plugins.go --registry=etcdv3 --registry_address=127.0.0.1:12379

start-client:
	go run client.go plugins.go --registry=etcdv3 --registry_address=127.0.0.1:12379


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
init-sv:
	[ -d /tmp/go-stack-guide ] || mkdir -p /tmp/go-stack-guide
