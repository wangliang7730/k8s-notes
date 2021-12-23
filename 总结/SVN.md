# SVN

## 安装

### Centos yum

```bash
yum install svn
```

## 示例

### 版本库默认位置

*/etc/sysconfig/svnserve*

```ini
OPTIONS="-r /var/svn"
```

### 建立版本库

```bash
mkdir -p /var/svn/svntest
svnadmin create /var/svn/svntest
```

### 配置

```bash
cd /var/svn/svntest
```

*conf/passwd*

```ini
admin = admin
guest = guest
```

*conf/authz*

```ini
[/]
admin = rw
guest = rdmin = rw
```

*conf/svnserve.conf*

```ini
anon-access = none
auth-access = write
password-db = passwd
authz-db = authz
```

重启

```bash
systemctl restart svnserve
```

