# Oracle

## 安装

### Windows

> ***下载***

- [下载 oracle](https://www.oracle.com/database/technologies/oracle-database-software-downloads.html)
- [下载 instantclient](https://www.oracle.com/database/technologies/instant-client/microsoft-windows-32-downloads.html)，base 和 sqlplus，解压到同一目录

> ***监听文件配置***

*`product\11.2.0\dbhome_1\NETWORK\ADMIN`* 目录下，*listener.ora* 和 *`listener.ora`* 和 *`nsnames.ora`* 修改 HOST 为主机 ip，然后，重启电脑。不重启用下面方式会报错。

```bash
lsnrctl stop
lsnrctl start
```

> ***连接***

```bash
sqlplus scott/scott@192.168.100.200:1521/orcl
```

### Docker

> ***参考：https://www.35youth.cn/685.html***

```bash
docker pull jaspeen/oracle-11g
# 上传 linux.x64_11gR2_database 到 /root/oracle
unzip linux.x64_11gR2_database_1of2.zip
unzip linux.x64_11gR2_database_2of2.zip
# 安装
docker run --privileged --name oracle11g -p 1521:1521 -v /root/oracle:/install jaspeen/oracle-11g
## 等待5-10分钟，输出 100% complete 安装成功
# 解锁 scott
docker exec -it oracle11g /bin/bash
su - oracle
sqlplus / as sysdba
alter user scott account unlock;
# alter user hr identified by hr account unlock;
# grant connect,resource,dba to hr;
commit;
# 重置密码
conn scott/tiger
# 停止
docker stop oracle11g
# 启动
docker start oracle11g
```

## 连接

### PL/SQL

- 设置 instantclient 路径和里面的 oci.dll 路径

## 基本

- 实例：orcl，一般一个就够了
- 用户：管理表的基本单位，对应于 MySQL 的数据库
- 表空间：存放数据文件的逻辑单位

```sql
-- 查看表
select * from tab
```

### 表空间

> ***创建***

```sql
-- 默认在 C:\oracle\product\11.2.0\dbhome_1\database
create tablespace <tablespace_name>
datafile '<filename>'
size 10m
autoextend on
next 10m
maxsize unlimited;
```

> ***删除***

```sql
drop tablespace <tablespace_name> [including contents and datafiles [cascade constraints]];
```

### 创建用户

```sql
create user <user_name>
identified by <password>
default tablespace <tablespace_name>;
```

### 解锁用户

```sql
alter user <user_name> account unlock;
-- 设置密码
alter user <user_name> identified by <password>
```

### 授权

```sql
grant dba to <user_name>;
```

> ***常用权限***

- dba、connect、resource

## 表 DDL

### 数据类型

- varchar、varchar2
- number(m,n)：m总位数，n小数位数
- date
- clob
- blob

### 创建表

```sql
create table <table_name> (
	id number(20),
  name varchar2(10)
);
```

### 修改表结构

```sql
-- 增加
alter table <table_name> add <column_name> <column_type>;
-- 修改类型
alter table <table_name> modify <column_name> <column_type>;
-- 修改名称
alter table <table_name> rename column <old_colum_name> to <new_colum_name>;
-- 删除
alter table <table_name> drop column <colum_name>;
```

## 数据 DML

- 涉及事务要手动 commit

### 序列

> ***创建***

```sql
create sequence <sequence_name>
increment by n
start with n;
```

> ***使用***

```sql
-- nextval、currval
select <sequence_name>.nextval from dual;
```

### join

> +

```sql
-- 左外连接
where t1.c1 = t2.c1(+)
```

### 分页

```sql
-- rownum 记录行号，所以基本写法是
select rownum, t.* from tbl t where rownum > r1 and rownum < r2
-- 但是如果排序会打乱 rownum，所以先排序，然后子查询
select rownum, t.* from (select * from tbl order by c) t where rownum > r1 and rownum < r2
-- 但是又有问题，rownum 是逐步增加，所以 rownum > r2 这个条件（如果r2大于0）永远不成立，所以再套一层
select * from (select rownum rn, t.* from (select * from tbl order by c) t where rownum < r2) where rn > r1
```

### 条件判断

> ***case***

```sql
-- 1
case 变量
when 值 then ...
else ... end
-- 2
case
when 条件 then ...
else ... end
-- decode
decode(条件,值1,返回值1,值2,返回值2,...值n,返回值n,缺省值)
```

## 函数

- nvl

### 字符串

- upper/lower

### 数值

- round
- trunc
- mod

### 日期

- sysdate：值，当前时间
- mouth_between
- to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss')
- to_date

## 视图

```sql
create view <view_name> as select * from t with read only;
```

## 索引

```sql
create index <index_name> on t(c);
```

## pl/sql

### 基础

```plsql
declare
begin
end;

-- 输出
dbms_output.put_line(s1 || s2);
```

### 变量

```plsql
-- 1
i number(2) := 10;
-- 输入
in number(2) := &in;

-- 2
c emp.ename%type;
select ename into c from emp where mgr is null;

-- 3
r emp%rowtype;
select * into c from emp where mgr is null;
```

### if

```plsql
if 条件 then
	...
elsif 条件 then
	...
else
	...
end if;
```

### 循环

```plsql
-- 1
while 条件 loop
	...
end loop;

-- 2
loop exit when 条件;
	...
end loop;

-- 3
for i in 1..10 loop
	...
end loop;
```

### 游标

```plsql
declare
	cursor c(参数名 参数类型) is select * from emp;
	r emp%rowtype;
begin
	open c(参数);
		loop
			fetch c into r;
			exit when c%notfound;
			...
		end loop;
	close c;
end;
```

## 存储过程

```plsql
create [or replace] procedure 名称(参数名 in/out 类型)
as
declare
begin
end;
```

## 存储函数

```plsql
create [or replace] function 名称(参数名 in/out 类型) return 数据类型
as
declare
begin
	return 变量名;
end;
```

## 触发器

```plsql
create [or replace] trigger 名称
before|after insert|update|delete on 表名 [for each row]
declare
	-- :old :new
begin
end;
```