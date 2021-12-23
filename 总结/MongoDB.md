# MongoDB

***GUI***

- Studio 3T

## [安装](https://docs.mongodb.com/manual/tutorial/install-mongodb-on-red-hat-tarball/)

### docker-compose

拷贝配置文件：`docker cp mongodb:/etc/mongod.conf.orig mongod.conf`

```yaml
version: '3'
services:
  mongodb:
    image: mongo
    restart: always
    container_name: mongodb
    volumes:
      - ./db:/data/db
      - ./log:/var/log/mongodb
    ports:
      - "27017:27017"
    environment:
      MONGO_INITDB_ROOT_USERNAME: admin
      MONGO_INITDB_ROOT_PASSWORD: admin
```

### tar

- 很不方便，只有 bin，连默认配置文件都没有

```bash
# 27017
mkdir -p /data/db
./bin/mongod --fork --logpath /var/log/mongo.log
./bin/mongod --shutdown
```

*`/etc/init.d/mongod`*

```bash
#!/bin/bash
# chkconfig:2345 10 90
# description:service mongod
MONGO_HOME=/usr/local/mongodb-linux-x86_64-rhel70-4.2.3
CMD=$MONGO_HOME/bin/mongod
case "$1" in
     start)   ${CMD} --fork --logpath /var/log/mongo.log;;
     stop)    ${CMD} --shutdown;;
     status)
        grep_result=`ps -ef | grep "$CMD" | grep -v grep`
        if [ -z "$grep_result" ]; then
          echo "maybe not running"
        else
          echo "$grep_result"
        fi
        ;;
    *)  echo "require start|stop|status";;
esac
```

### rpm

下载 mongodb-org-server 直接安装

*`/etc/mongod.conf`*

```yaml
net:
	port: 27017
	bind_ip: 0.0.0.0
```

```bash
service mongod start
```

### [yum](https://developer.aliyun.com/mirror/mongodb)

*` /etc/yum.repos.d/mongodb-org.repo`*

```bash
[mongodb-org] 
name=MongoDB Repository
baseurl=https://mirrors.aliyun.com/mongodb/yum/redhat/7/mongodb-org/4.2/x86_64/
gpgcheck=0 
enabled=1
```

```bash
yum install mongodb-org
```

## 基本操作

### 创建用户

```shell
db.createUser({user: "testUser", pwd: "pwd", roles : [{role: "readWrite", db: "interviewTest"}]});
```

### 数据库

```bash
show dbs # 显示所有数据库，空数据不会显示
db # 显示当前数据库
use # 选择数据库，无需存在
```

### 集合

```shell
show collections # 显示所有集合
```

### 插入

```shell
db.foo.inert({})
db.foo.insertOne({})
db.foo.insertMany([])
```

### 查询

```shell
find({条件},{映射})
findOne({},{})

# 条件
{
  # 等于
  foo: 'xxx',
  # AND
  bar: {
    # 小于：$lt/$lte/$gt/$gte/$ne
    $lt: 2,
    # AND
    $gt: 1,
    # $nin
    $in: [],
  },
  # AND(...OR...)
  $or: [
    {foo: /正则/},
    # OR
    {bar: 2}
  ],
  $where: function() {
    return this.foo === 'bar'
  }
}

# 映射：指定返回字段
# 默认_id是包含在结果集合中的，除了_id字段，不能在一个projection中联合使用包含和排除语意
# 包含foo、bar，排除_id
{
  foo: 1,
  bar: 1
  _id: 0
}
# 排除foo、bar
{
  foo: 0,
  bar: 0
}
```

### 更新

```bash
# 默认只更新一个，没有指定的会赋值为空
update({条件}, {更新内容})
updateOne
updateMany

# 只更新指定的字段，并且更新多个
{$set: {foo: 'bar'}, {multi: true}}
```

### 删除

```shell
remove({条件})
```

