# Nginx

## 安装

```bash
yum install -y gcc-c++ pcre-devel zlib-devel
tar -zxvf nginx-1.16.1.tar.gz -C /usr/local/
./configure
make
make isntall
```

## docker-compose

```yaml
version: '3'
services:
  nginx:
    restart: always
    image: nginx
    container_name: nginx
    ports:
     - 80:80
     - 443:443
    volumes:
     - ./conf.d:/etc/nginx/conf.d
     - ./html:/usr/share/nginx/html
     - ./letsencrypt:/etc/letsencrypt
    network_mode: bridge
```

## try_files

```nginx
location / {
    try_files $uri $uri/ /index.html?$query_string;
}
```

## 证书

安装：

```shell
curl https://get.acme.sh | sh
# 网络原因访问不了
# 直接获取 https://github.com/acmesh-official/acme.sh/blob/master/acme.sh
sh acme.sh --install
acme.sh --register-account -m my@example.com
```

自动方式：不知道为什么不行

```shell
# 配置alikey https://ram.console.aliyun.com/manage/ak 或者 https://ram.console.aliyun.com/users/new
export Ali_Key="LTAI5tDL2Vv9aMtxk3PeFVU2"
export Ali_Secret="LpaPNbyrVKiAj95Xv22aoULtjGqCXp"
# 获取证书
acme.sh --issue --dns dns_ali -d *.sharonlee.top
```

手动方式：

```shell
acme.sh --issue -d *.sharonlee.top --dns --yes-I-know-dns-manual-mode-enough-go-ahead-please
# 设置txt
acme.sh --issue -d *.sharonlee.top --dns --yes-I-know-dns-manual-mode-enough-go-ahead-please --renew

Your cert is in: /root/.acme.sh/*.sharonlee.top/*.sharonlee.top.cer # 域名证书
Your cert key is in: /root/.acme.sh/*.sharonlee.top/*.sharonlee.top.key # 密钥
The intermediate CA cert is in: /root/.acme.sh/*.sharonlee.top/ca.cer # CA 证书
And the full chain certs is there: /root/.acme.sh/*.sharonlee.top/fullchain.cer # 证书链
# 还有域名.csr 证书签名
```

配置：

```nginx
# ssl证书地址
ssl_certificate     /root/.acme.sh/*.sharonlee.top/fullchain.cer;
ssl_certificate_key  /root/.acme.sh/*.sharonlee.top/*.sharonlee.top.key;

# ssl验证相关配置
ssl_session_timeout  5m;    #缓存有效期
ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE:ECDH:AES:HIGH:!NULL:!aNULL:!MD5:!ADH:!RC4;    #加密算法
ssl_protocols TLSv1 TLSv1.1 TLSv1.2;    #安全链接可选的加密协议
ssl_prefer_server_ciphers on;   #使用服务器端的首选算法
```

## 参考

[^1]: https://blog.iwyc.cn/ssl

