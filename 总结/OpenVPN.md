# OpenVPN

## 下载

https://build.openvpn.net/downloads/releases/latest/

## 安装

***安装***

```bash
yum install openvpn
yum install easy-rsa
```

***准备相关目录和配置文件***

```bash
cp -r /usr/share/easy-rsa/3.0.7 /etc/openvpn/server/easy-rsa
#cp -r /usr/share/easy-rsa/3.0.7 /etc/openvpn/client/easy-rsa
cp /usr/share/doc/easy-rsa-3.0.7/vars.example /etc/openvpn/server/easy-rsa/vars
#cp /usr/share/doc/easy-rsa-3.0.7/vars.example /etc/openvpn/client/easy-rsa/vars
cp /usr/share/doc/openvpn-2.4.9/sample/sample-config-files/server.conf /etc/openvpn
cp /usr/share/doc/openvpn-2.4.9/sample/sample-config-files/client.conf /etc/openvpn
openvpn --genkey --secret /etc/openvpn/ta.key
```

***创建服务端证书***

```bash
cd /etc/openvpn/server/easy-rsa/
# 创建空的pki，执行两次【yes】
./easyrsa init-pki
# 创建新的CA，不使用密码【回车】
./easyrsa build-ca nopass
# 创建服务端证书【回车】
./easyrsa gen-req server nopass
# 签约服务端证书【yes】
./easyrsa sign server server
# 创建Diffie-Hellman
./easyrsa gen-dh
```

***创建客户端证书***

```bash
#cd /etc/openvpn/client/easy-rsa/
# 创建空的pki，执行两次【yes】
#./easyrsa init-pki
# 客户端证书1【回车】
./easyrsa gen-req client1 nopass
# 导入客户端证书
#cd /etc/openvpn/server/easy-rsa/
#./easyrsa import-req /etc/openvpn/client/easy-rsa/pki/reqs/client1.req client1
# 签约客户端证书【yes】
./easyrsa sign client client1
```

***复制证书***

```bash
cp /etc/openvpn/server/easy-rsa/pki/dh.pem /etc/openvpn/server
cp /etc/openvpn/server/easy-rsa/pki/ca.crt /etc/openvpn/server
cp /etc/openvpn/server/easy-rsa/pki/issued/server.crt /etc/openvpn/server
cp /etc/openvpn/server/easy-rsa/pki/private/server.key /etc/openvpn/server

cp /etc/openvpn/server/easy-rsa/pki/ca.crt /etc/openvpn/client
cp /etc/openvpn/server/easy-rsa/pki/issued/client1.crt /etc/openvpn/client
cp /etc/openvpn/server/easy-rsa/pki/private/client1.key /etc/openvpn/client
```

***配置 OpenVPN***

```bash
# 查看配置
egrep -v "^$|^#|^;" /etc/openvpn/server.conf

ca /etc/openvpn/server/ca.crt
cert /etc/openvpn/server/server.crt
key /etc/openvpn/server/server.key
dh /etc/openvpn/server/dh.pem
```

***启动***

```bash
systemctl start openvpn@server
```