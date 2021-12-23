# MySQL

# MySQL

## CentOS 安装 MySQL

**安装：**

```shell
# 下载
curl https://mirrors.163.com/mysql/Downloads/MySQL-5.7/mysql-5.7.36-1.el7.x86_64.rpm-bundle.tar -O

# 解压
mkdir mysql && tar -xvf mysql-5.7.36-1.el7.x86_64.rpm-bundle.tar -C mysql

# 安装
cd mysql && yum install -y mysql-community-{server,client,common,libs}-*

# 启动
systemctl enable mysqld --now
```

**重置密码，允许远程登录：**

```shell
# 查看密码
grep 'temporary password' /var/log/mysqld.log

# 登录
mysql -uroot -p

# 重置密码，允许远程登录
set global validate_password_policy = 0;
set global validate_password_mixed_case_count = 0;
set global validate_password_number_count = 0;
set global validate_password_special_char_count = 0;
set global validate_password_length = 0;
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root';
use mysql;
update user set host='%' where user='root';
```

**配置：**

`/etc/my.cnf`：

```shell
[client]
default-character-set=utf8mb4

[mysql]
default-character-set=utf8mb4

[mysqld]
character-set-server=utf8mb4
lower_case_table_names=1
sql_mode=STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION,NO_AUTO_VALUE_ON_ZERO
max_allowed_packet=1024m
```

**重启：**

```shell
systemctl restart mysqld
```

**参考：**

- [官网 - Installing MySQL on Linux Using RPM Packages from Oracle](https://dev.mysql.com/doc/refman/5.7/en/linux-installation-rpm.html)。

## 使用

### 批量转换字符编码

```mysql
select 
    CONCAT('alter table ',a.table_name,' convert to character set utf8mb4 collate utf8mb4_general_ci;') 
from (select table_name from information_schema.`TABLES` where TABLE_SCHEMA = '这里写数据库的名字其他地方不用改') a;
```

### 0 不要自增

```shell
NO_AUTO_VALUE_ON_ZERO
```

### 逗号隔开字段

```sql
SELECT GROUP_CONCAT(COLUMN_NAME SEPARATOR ",") FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'hzero_platform' AND TABLE_NAME = 'iam_role'
```

### sql 日志

```sql
show variables like 'general%log%';
set global general_log=1;
```

### 部署

```yaml

version: '3'
services:
  mysql:
    image: mysql:${MYSQL_VERSION}
    restart: always
    container_name: mysql
    ports:
      - 3306:3306
    volumes:
      - ./data:/var/lib/mysql
    environment:
      TZ: Asia/Shanghai
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
    command:
      --max_connections=2000
      --character_set_server=utf8mb4
      --collation_server=utf8mb4_bin
      --lower_case_table_names=1
      --max_allowed_packet=32M
      --sql_mode="NO_AUTO_VALUE_ON_ZERO,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION,NO_ZERO_DATE,NO_ZERO_IN_DATE,ERROR_FOR_DIVISION_BY_ZERO"
```



## MySQL Proxy

下载：https://downloads.mysql.com/archives/proxy/

***mysql-proxy.cnf***

```ini
admin-address=localhost:4041  
admin-username=mytest  
admin-password=123456  
proxy-backend-addresses=192.168.1.241:3306  
```

## 示例

### 官方测试数据库

- https://launchpad.net/test-db/+download

## 安装

### rpm-bundle

参考：https://dev.mysql.com/doc/refman/5.7/en/linux-installation-rpm.html

下载：https://mirrors.163.com/mysql/Downloads/MySQL-5.7/mysql-5.7.36-1.el7.x86_64.rpm-bundle.tar

```bash
mkdir mysql
tar -xvf mysql-5.7.36-1.el7.x86_64.rpm-bundle.tar -C mysql
cd mysql
yum install mysql-community-{server,client,common,libs}-*
systemctl start mysqld

# 启动失败
chmod -R 777 /var/lib/mysql
rm -rf /var/lib/mysql
```

> ***密码***

```mysql
grep 'temporary password' /var/log/mysqld.log
set global validate_password_policy = 0;
set global validate_password_mixed_case_count = 0;
set global validate_password_number_count = 0;
set global validate_password_special_char_count = 0;
set global validate_password_length = 0;
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root';
use mysql;
update user set host='%' where user='root';
#grant all privileges on *.* to 'root'@'%' identified by 'root';
```

*`/etc/my.cnf`*：

```ini
[client]
default-character-set=utf8mb4
[mysql]
default-character-set=utf8mb4
[mysqld]
character-set-server=utf8mb4
lower_case_table_names=1
sql_mode=STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION,NO_AUTO_VALUE_ON_ZERO
max_allowed_packet=1024m
```

### yum

```bash
yum list installed | grep mysql
yum -y remove ...
rpm -Uvh https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm
yum repolist enabled | grep "mysql.*-community.*"
vim /etc/yum.repos.d/mysql-community.repo
yum install mysql-community-server
```

***mariadb***

```bash
yum install mariadb mariadb-server
systemctl start mariadb
systemctl enable mariadb
mysql_secure_installation
```



## 基本

### 库操作

```mysql
-- 创建
create database if not exists 数据库名 character set utf8;
-- 删除
drop database if exists 数据库名;
-- 修改
alter database 数据库名 character set utf8mb4;
-- 使用
use 数据库名;
-- 查看
show databases;
show create database 数据库名;
select database();
```

### 表操作

```mysql
create table(
  列名 数据类型,
  ,,,
) engine=InnoDB default charset=utf8;
-- 复制表
create table 表名 like 表名1;
-- 删除表
drop table if exists 表名;
-- 查看
show tables;
desc 表名;

-- 修改表名
alter table 表名 rename to 新表名;
-- 修改表属性
alter table 表名 set character set utf8mb4;

-- 添加列
alter table 表名 add 列名 数据类型;
-- 修改列
alter table 表名 modify 列名 数据类型;
-- 修改列包括列名
alter table 表名 change 列名 新列名 新数据类型;
-- 修改排序
first | after 列名
-- 删除列
alter table 表名 drop 列名;
```

### 增删改

```mysql
-- 插入
inert into 表名(列名1, 列名2, ...) values(值1, 值2, ...),(...);
-- 删除
delete from 表名 where;
truncate table 表名：
drop table 表名
-- 更新，可以同时多表
update 表名 set 列名1=值1, 列名2=值2, ... where
```

### 查询

```mysql
-- 查询
select distinct * from 表名 where 
	group by
	with rollup -- 分组的结果汇总 
	having
	order by
	limit [偏移, ]行数
```

***多表查询***

```mysql
-- 隐式内连接
select * from 表1,表2 where 表1.列 = 表2.列
-- 显式内连接
select * from 表1 inner join 表2 on 表1.列 = 表2.列
-- 左外连接
select * from 表1 left outer join 表2 on 表1.列 = 表2.列
-- 右外连接
select * from 表1 right outer join 表2 on 表1.列 = 表2.列
```

***联合查询***

```mysql
union [all] -- all 不会去重
```

### 数据类型

***整数***

```mysql
tinyint smallint mediumint int/integer bigint
1       2        3         4           8
-- int(n) zerofill，显示时填充 0
```

***小数***

```mysql
-- 浮点数
float double
4     8
-- 定点数
decimal(M,D) # (总精度,小数位数)，默认(10,0)
```

***日期***

```mysql
# 范围
date -- 1000-01-01~9999-12-31
time -- -838:59:59.000000~838:59:59.000000
datetime -- 1000-01-01 00:00:00.000000~9999-12-31 23:59:59.999999
timestamp -- 1970-01-01 00:00:01.000000~2038-01-19 03:14:07.999999
year -- 1901~2155

# 格式
-- yyyy-mm-dd hh:mm:ss
-- yyyymmddhhmmss，字符串或数字
```

timestamp：

- 范围 1970 到 2038，比较小

- 新增或更新为 null 时，第一列自动 CURRENT_TIMESTAMP，explicit_defaults_for_timestamp 控制是否需要显示指定

- 受时区影响：time_zone

***字符/二进制/块***

```mysql
char -- 255，会删除末尾空格
varchar -- 列一共 65535 字节，utf-8 21844，0-255一个额外前缀字节记录长度,256-65535 两个
tinytext tinyblob -- 2^(8*1)=255 + 1
text blob -- 2^(8*2)=65535=64k + 2
mediumtext mediumblob -- 2^(8*3)=16M + 3
longtext longblob -- 2^(8*4)=4G + 4
```

***位***

```mysql
bit(n) -- 1-64位
-- 用 bin()、oct() 或 hex() 显示
```

***enum/set***

```mysql
enum/set('a', 'b')
values('a,b')
```

### 运算符

- <=>：可以比较 NULL

### `DISTINCT`

**语法：**

```mysql
SELECT DISTINCT select_list
```

- `NULL` 合成一个
- 多个字段只要有一个不同就认为不同
- 可以认为是简单的 `GROUP BY`，区别是后者会排序
- 可用于聚合函数，比如 `COUNT(DISTINCT colume)`
- 有 `LIMIT` 时，`DISTINCT` 先执行

>   MySQL 8 中 `GROUP BY` 默认不会排序了

## 函数

### 字符函数

```mysql
concat
insert(str,pos含,个数,替换)
upper/lower
left/right(str,个数)
substr(str,pos含,个数)
lpad/rpad(str,n,pad)
trim/ltrim/rtrim
repeat(str,n)
replace(str,字符,替换为)
strcmp
```

### 数值函数

```mysql
abs
ceil/floor
round(x,小数位数)
truncate(x,小数位数)
mod(除数,被除数)
rand() -- 0~1的随机数
```

### 时间函数

```mysql
-- 当前时间
curdate/curtime/now
-- 时间戳转换
unix_timestamp(t)
from_unixtime(t)
-- 取值
year/month/monthname/hour/minute/second
week -- 一年中第几周
-- 计算
date_add(date,INTERVAL expr unit) -- https://devdocs.io/mariadb/date_add/index
date_diff()
-- 格式化
date_format(d,fmt) -- https://devdocs.io/mariadb/date_format/index
```

### 条件判断

```mysql
if(条件,真,假)
ifnull(不为空,为空)
case 值 when 比较值 then 返回值 ... else 返回值 end -- switch
case when 条件 then 返回值 ... else 返回值 end -- if
```

### 其他

```mysql
database
version
user
password
md5

-- ip 转换数字，可以排序
inet_aton -- ip -> 数字
inet_ntoa -- 数字 -> ip

last_insert_id
```

## 约束

### 非空约束

```mysql
-- 创建时添加
列名 数据类型 not null：
-- 修改时添加
alter table 表名 modify 列名 数据类型 not null;
-- 删除
alter table 表名 modify 列名 数据类型;
```

### 唯一索引

- 唯一约束可以有多个 null

```mysql
-- 创建时添加
列名 数据类型 unique：
-- 修改时添加，索引名可省略，默认和列名一致
alter table 表名 add unique index 索引名(列名);
alter table 表名 modify 列名 数据类型 unique;
-- 重命名
alter table 表名 rename index 索引名 to 新索引名;
-- 删除
alter table 表名 drop index 索引名;
```

### 主键约束

```mysql
-- 创建时添加
列名 数据类型 primary key：
-- 修改时添加
alter table add primary key (列名);
alter table 表名 modify 列名 数据类型 primary key;
alter table 表名 modify 列名 数据类型 not null first, add primary key (列名);
-- 删除
alter table 表名 drop primary key;
-- 自增
```

### 自动增长

```mysql
-- 创建时添加
列名 数据类型 auto_increment;
-- 修改时添加
alter table 表名 modify 列名 数据类型 auto_increment;
-- 删除
alter table 表名 modify 列名 数据类型;
```

- 自增列必须是索引，innodb 必须是第一个索引，myisam 可以不是

### 外键约束

```mysql
-- 创建时添加
列名 数据类型 constraint 外键名称 foreign key (外键列) references 主表名(主表列名);
-- 修改时添加
alter table 表名 add constraint 外键名称 foreign key (外键列) references 主表名(主表列名);
-- 删除
alter table 表名 drop foreign key 外键名称;
-- 更新删除时 ristrict|cascade|no action|set null
on update cascade, on delete cascade
```

## 事务

```mysql
start transaction;
commit;
rollback;
```

- 自动提交：autocommit
- 隔离级别：tx_isolation

## 索引

```mysql
CREATE [UNIQUE|FULLTEXT|SPATIAL] INDEX index_name
	[USING index_type]
	ON tbl_name(index_col_name,...)

index_type:
	USING {BTREE | HASH}

DROP INDEX index_name ON tbl_name
```

## 变量

```mysql
-- 全局变量
@@global.变量名
-- 会话变量
@@session.变量名
@@变量名

foreign_key_checks
datadir
```

## 用户管理

### 用户

```mysql
-- 切换到 mysql 数据库
use mysql;
-- 查询
select * from user;
-- 创建
create user 用户名@主机名 identified by 密码;
-- 删除
drop user 用户名@主机名;
-- 设置密码
update user set password = password(密码) where 条件;
set password for 用户名@主机名 = password(密码);
-- 无验证
mysqld --skip-grant-tables
```

### 权限

```mysql
-- 查询
show grants for 用户名@主机名;
-- 授予
grant 权限 on 数据库名.表名 to 用户名@主机名;
grant all on *.* to 用户名@主机名;
-- 撤销
revoke 权限 on 数据库名.表名 from 用户名@主机名;
```

## 备份/还原

```bash
mysqldump -h主机 -P端口 -u用户 -p密码 --database 数据库名 > backup.sql
source backup.sql
```
