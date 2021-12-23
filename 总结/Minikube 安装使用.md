---
date: 2021-07-03
---

# Minikube 安装使用

## 安装 Minikube

**参考：**

- [【Github】kubernetes/minikube](https://github.com/kubernetes/minikube)
- [【Github】/AliyunContainerService/minikube](https://github.com/AliyunContainerService/minikube)

- [【阿里云】Minikube - Kubernetes本地实验环境](https://developer.aliyun.com/article/221687)

- [【K8S 官网】使用 Minikube 安装 Kubernetes](https://v1-18.docs.kubernetes.io/zh/docs/setup/learning-environment/minikube/)

- [【K8S 官网】你好 Minikube](https://v1-18.docs.kubernetes.io/zh/docs/tutorials/hello-minikube/)

> **⚠️ X Exiting due to RSRC_INSUFFICIENT_CORES: Requested cpu count 2 is greater than the available cpus of 1**
>
> cpu 的数量需要 > 1

```shell
curl -Lo minikube https://kubernetes.oss-cn-hangzhou.aliyuncs.com/minikube/releases/v1.18.1/minikube-linux-amd64
chmod +x minikube
mv minikube /usr/local/bin/
```

## 启动

```shell
# 默认在虚拟环境中运行，不能以 root 运行
minikube start
```

> **⚠️ X Exiting due to DRV_AS_ROOT: The “docker” driver should not be used with root privileges.**
>
> - https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user
>
> 不能以 root 运行
>
> ```shell
> 
> adduser minikube
> usermod -aG docker minikube
> su minikube
> ```

```shell
# 在宿主机中运行，用 root
[root] minikube start --registry-mirror=https://9siv5tg6.mirror.aliyuncs.com --image-repository=registry.cn-hangzhou.aliyuncs.com/google_containers --driver=none
```

> ⚠️ **Exiting due to PROVIDER_NONE_NOT_FOUND: The 'none' provider was not found: running the 'none' driver as a regular user requires sudo permissions**
>
> ⚠️ **X Exiting due to GUEST_MISSING_CONNTRACK: Sorry, Kubernetes 1.20.2 requires conntrack to be installed in root's path**
>
> ```shell
> yum -y install conntrack
> ```
>
> ⚠️ **[ERROR FileContent--proc-sys-net-bridge-bridge-nf-call-iptables]: /proc/sys/net/bridge/bridge-nf-call-iptables contents are not set to 1**
>
> ```shell
> echo "1" >/proc/sys/net/bridge/bridge-nf-call-iptables
> ```

## 安装 kubectl

**参考：**

- [kubectl 安装](https://kubernetes.feisky.xyz/setup/kubectl)
- [【K8S官网】在 Linux 系统中安装并设置 kubectl](https://kubernetes.io/zh/docs/tasks/tools/install-kubectl-linux/)
- https://github.com/kubernetes/kubernetes/tree/master/CHANGELOG

```shell
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
yum install -y kubectl
```

## 基本使用

```shell
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/echoserver:1.10
kubectl create deployment hello-minikube --image=registry.cn-hangzhou.aliyuncs.com/google_containers/echoserver:1.10
kubectl expose deployment hello-minikube --type=NodePort --port=8080
kubectl get pod
minikube service hello-minikube --url
kubectl get service
minikube service hello-minikube
kubectl delete services hello-minikube
kubectl get deployment
kubectl delete deployment hello-minikube
kubectl get pod
kubectl delete pod hello-minikube-xxx
minikube stop
minikube delete
```

## 安装 dashboard

```shell
# 默认在前台运行
minikube dashboard --url

# 默认在前台运行
kubectl proxy --address='0.0.0.0' --accept-hosts='^.*$'
# http://192.168.128.10:8001/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/
```

## 重启

```shell
systemctl start kubelet
```

