# ####################################
# Micro API Sub File
# ####################################


API_PORT		:= 58081
EVENT_PORT	:= 58082
META_PORT		:= 58083
PROXY_PORT	:= 58084
RPC_PORT		:= 58085
WEB_PORT		:= 8080


# ####################################
# Dashboard AREA
# ####################################
run-test: run-api-test run-proxy-test run-meta-test run-rpc-test



# ####################################
# API-API AREA
# ####################################
start-api-gw:
	micro api --handler=api --address=":${API_PORT}"
start-api-server:
	go run api/api.go
run-api-test:
	@echo "GET example/call => Example.Call"
	curl -H 'head-1: I am a header' "http://localhost:${API_PORT}/example/call?name=john"
	@echo;
	@echo;
	@echo "POST example/foo/bar => Foo.Bar"
	curl -H 'Content-Type: application/json' -d '{data:api-data-$(API_PORT)-$(DATA_SUF)}' http://localhost:${API_PORT}/example/foo/bar
	@echo;


# ####################################
# Event AREA
# ####################################
start-event-gw:
	micro api --handler=event --address=":${EVENT_PORT}" --namespace=go.micro.evt
start-event-server:
	go run event/main.go
run-event-test:
	curl -d '{"message": "Hello, Micro中国"}' http://localhost:${EVENT_PORT}/user/login


# ####################################
# API-Meta AREA
# ####################################
start-meta-gw:
	micro api --address=":${META_PORT}"
start-meta-server:
	go run meta/meta.go
run-meta-test: run-meta-test-post-1 run-meta-test-post-2
run-meta-test-post-1:
	@echo "向 **/example** POST请求时，会被转到**go.micro.api.example**的**Example.Call**方法。"
	curl -H 'Content-Type: application/json' -d '{"name": "john"}' "http://localhost:${META_PORT}/example"
	curl -XGET "http://localhost:${META_PORT}/example?name=john"
	@echo; echo;
run-meta-test-post-2:
	@echo "向 **/example** POST请求时，会被转到**go.micro.api.example**的**Foo.Bar**方法。"
	curl -H 'Content-Type: application/json' -d '{}' http://localhost:${META_PORT}/foo/bar
	curl -XGET "http://localhost:${META_PORT}/foo/bar"
	curl -XDELETE "http://localhost:${META_PORT}/foo/bar"
	@echo; echo;


# ####################################
# API-Proxy AREA
# ####################################
start-proxy-gw:
	micro api --handler=proxy --address=":${PROXY_PORT}"
start-proxy-server:
	go run proxy/proxy.go
run-proxy-test: run-proxy-test-get run-proxy-test-post run-proxy-test-web
run-proxy-test-get:
	@echo "发送请求到 /example/call，该请求会被 API 反向代理到 go.micro.api.example 服务的 /example/call 路由"
	curl "http://localhost:${PROXY_PORT}/example/call?name=micro"
	@echo;
	@echo;
run-proxy-test-post:
	@echo "POST请求到 **/example/foo/bar**会调用**go.micro.api.example**的 **/example/foo/bar**路由。"
	curl -H 'Content-Type: application/json' -d '{"name": "micro"}' http://localhost:${PROXY_PORT}/example/foo/bar
	@echo;
	@echo;
run-proxy-test-web:
	@echo "我们可以请求http://localhost:${PROXY_PORT}/example/foo/upload，获取上传页面，选择适当的文件上传，测试上传功能。"
	@echo "为了方便和直观，请确保上传保存的目录存在，且上传小文件"
	@echo;


# ####################################
# API-RPC AREA
# 需要提醒的是，RPC模式下**API**只接收POST方式的请求，
# 并且只支持内容格式**content-type**为
#	**application/json**或者**application/protobuf**
# ####################################
start-rpc-gw:
	micro api --handler=rpc --address=":${RPC_PORT}"
start-rpc-server:
	go run rpc/rpc.go
run-rpc-test: run-rpc-test-post-1 run-rpc-test-post-2
	@echo "需要提醒的是，RPC模式下**API**只接收POST方式的请求，并且只支付内容格式**content-type**为**application/json**或者**application/protobuf**。"
run-rpc-test-post-1:
	@echo "当我们POST请求到 **/example/call**时，**API**会将它转成RPC转发到**go.micro.api.example**服务的**Example.Call**接口上。"
	curl -H 'Content-Type: application/json' -d '{"name": "小小先"}' "http://localhost:${RPC_PORT}/example/call"
	@echo; echo
run-rpc-test-post-2:
	@echo "同样，POST请求到 **/example/foo/bar**时，**API**会将它转成RPC转发到**go.micro.api.example**服务的**Foo.Bar**接口上。"
	curl -H 'Content-Type: application/json' -d '{}' http://localhost:${RPC_PORT}/example/foo/bar
	@echo; echo


# ####################################
# API-Web AREA
# ####################################
start-web-gw:
	micro api --handler=web --address=":${WEB_PORT}"
start-web-server:
	# go run web/web.go
	cd web && go run web.go
run-web-test:
	@echo "打开 http://127.0.0.1:8080/websocket/"
