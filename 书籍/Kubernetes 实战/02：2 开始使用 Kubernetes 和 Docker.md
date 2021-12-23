---
date: 2021-12-08
updated: 2021-12-12
---

# 2 开始使用 Kubernetes 和 Docker

## 2.1 创建、运行及共享容器镜像

### 2.1.1 安装 Docker 并运行 Hello World 容器

```shell
docker run busybox echo "Hello world"
```

### 2.1.2 创建一个简单的 Node.js 应用

`app.js`：

```js
const http = require('http');
const os = require('os');

console.log("Kubia server starting...");

var handler = function(request, response) {
  console.log("Received request from " + request.connection.remoteAddress);
  response.writeHead(200);
  response.end("You've hit " + os.hostname() + "\n");
};

var www = http.createServer(handler);
www.listen(8080);
```

### 2.1.3 为镜像创建 Dockerfile

`Dockerfile`：

```dockerfile
FROM node:7
ADD app.js /app.js
ENTRYPOINT ["node", "app.js"]
```

### 2.1.4 构建容器镜像

```shell
docker build -t kubia .
```

### 2.1.5 运行容器镜像

```shell
docker run --name kubia-container -p 8080:8080 -d kubia
```

### 2.1.6 探索运行容器的内部

```shell
docker exec -it kubia-container bash
```

### 2.1.7 停止和删除容器

```shell
docker stop kubia-container
docker rm kubia-container
```

### 2.1.8 向镜像仓库推送镜像

```shell
docker tag kubia luksa/kubia
docker push luksa/kubia
docker run -p 8080:8080 -d luksa/kubia
```

## 2.2 配置 Kubernetes 集群

### 2.2.1 用 Minikube 运行一个本地单节点 Kubernetes 集群

**安装 Minikube：**

```shell
curl -Lo minikube https://storage.googleapis.com/minikube/releases/v0.23.0/minikube-darwin-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
```

**使用 Minikube 启动一个 Kubernetes 集群：**

```shell
minikube start
```

**安装 Kubernetes 客户端（kubectl）：**

```shell
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/darwin/amd64/kubectl && chmod +x kubectl && sudo mv kubectl /usr/local/bin/
```

**使用 kubectl 查看集群是否正常工作：**

```shell
kubectl cluster-info
```

### 2.2.2 使用 Google Kubernetes Engine 托管 Kubernetes 集群

略。

### 2.2.3 为 kubectl 配置别名和命令行补齐

**创建别名：**

```shell
alias k=kubectl
```

**为 kubectl 配置 tab 补全：**

```shell
source <(kubectl completion bash)
# 如果使用了别名
source <(kubectl completion bash | sed s/kubectl/k/g)
```

## 2.3 在 Kubernetes 上运行第一个应用

### 2.3.1 部署 Node.js 应用

```shell
kubectl run kubia --image=luksa/kubia --port=8080 --generator=run/v1
```

> 🙋‍♂️ **报错：unknown flag: --generator**
>
> `--generator=run/v1` 已经被弃用，可以使用 yaml 创建 rc：
>
> `kubia-rc.yaml`：
>
> ```yaml
> apiVersion: v1
> kind: ReplicationController
> metadata:
>   name: kubia
> spec:
>   replicas: 1
>   selector:
>     app: kubia
>   template:
>     metadata:
>       name: kubia
>       labels:
>         app: kubia
>     spec:
>       containers:
>       - name: kubia
>         image: luksa/kubia:2.0
>         imagePullPolicy: IfNotPresent
>         ports:
>         - containerPort: 8080
> ```
>
> ```shell
> kubectl create -f kubia-rc.yaml
> ```

**列出 pod：**

```shell
kubectl get pods
```

### 2.3.2 访问 Web 应用

**创建一个服务对象：**

```shell
kubectl expose rc kubia --type=LoadBalancer --name kubia-http
```

**列出服务：**

```shell
kubectl get services
```

> **注意：** Minikube 不支持 LoadBalancer 类型的服务，用下面命令列出 url：
>
> ```shell
> minikube service kubia-http
> ```

### 2.3.3 系统的逻辑部分

略。

### 2.3.4 水平伸缩应用

**增加期望的副本数：**

```shell
kubectl scale rc kubia --replicas=3
kubectl get rc
```

### 2.3.5 查看应用运行在哪个节点上

**列出 pod 时显示 pod IP 和 pod 的节点：**

```shell
kubectl get pods -o wide
```

**使用 kubectl describe 查看 pod 的其他细节：**

```shell
kubectl describe pod kubia-xxx
```

### 2.3.6 介绍 Kubernetes dashboard

**访问 Minikube 的 dashboard：**

```shell
minikube dashboard
```

> 🙋‍♂️ 外部访问：
>
> ```shell
> kubectl proxy --address='0.0.0.0' --disable-filter=true
> http://192.168.100.100:8001/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/
> ```

## 2.4 本章小结

略。

