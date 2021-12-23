# Named

## 安装

```shell
yum install bind bind-utils -y
vim /etc/named.conf # any
vim /etc/named.rfc1912.zones

zone "novapaas.local" IN {
        type master;
        file "novapaas.local.zone";
        allow-update { none; };
};

cp -a /var/named/named.localhost /var/named/novapaas.local.zone
vim /var/named/novapaas.local.zone

$TTL 3H
@       IN SOA  @ rname.invalid. (
                                        0       ; serial
                                        1D      ; refresh
                                        1H      ; retry
                                        1W      ; expire
                                        3H )    ; minimum
        NS      @
        A       127.0.0.1
        AAAA    ::1
test    IN A    10.10.120.38

# 检查
/usr/sbin/named-checkconf -z

# 防火墙
iptables -A INPUT -i eth0 -p udp --dport 53 -j ACCEPT
iptables -A INPUT -i eth0 -p tcp --dport 53 -j ACCEPT
```

