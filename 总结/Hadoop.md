# Hadoop

winutils：

- https://github.com/steveloughran/winutils
- https://github.com/cdarlint/winutils

## 环境搭建

```bash
yum install rsync
```

```bash
#!/bin/bash
# 拷贝到文件到相同位置

if (($# < 2)); then
  echo "usage: myrsync file host1 host2 ..."
  exit
fi
# 文件名
fname=$(basename $1)
# 文件所在绝对路径
path=$(
  cd "$(dirname "$1")"
  pwd -P
)
# 文件全路径
fpath="$path/$fname"
# 跳过第一个参数
shift
# 循环拷贝
for host in $@; do
  cmd="rsync -av $fpath $host:$path"
  echo "$cmd"
  eval $cmd
done
```

***环境变量***

```bash
# JAVA_HOME
export JAVA_HOME="/usr/local/jdk1.8.0_202"
export PATH=$PATH:$JAVA_HOME/bin
# HADOOP_HOME
export HADOOP_HOME="/usr/local/hadoop-2.10.0"
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
```

## 示例

```bash
bin/hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-2.10.0.jar grep input output 'dfs[a-z.]+'
bin/hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-2.10.0.jar wordcount input output
```

## 配置

配置文件都在 *`etc/hadoop`* 下，基本形式如下，为了简便，以键值对形式给出

```xml
<configuration>
    <property>
        <name>key</name>
        <value>value</value>
    </property>
</configuration>
```

配置：

```ini
# core-site.xml
fs.defaultFS=hdfs://11.com:9000
hadoop.tmp.dir=/tmp/hadoop-${user.name}

# hdfs-site.xml
dfs.replication=3
dfs.namenode.secondary.http-address=12.com:50090
# 心跳，超时时间=2*recheck-interval+10*interval
dfs.namenode.heartbeat.recheck-interval=300000
dfs.heartbeat.interval=3
# 白名单
dfs.hosts=/foo/dfs.hosts
# 黑名单
dfs.hosts.exclude=/foo/dfs.hosts.exlude

# yarn-site.xml
yarn.nodemanager.aux-services=mapreduce_shuffle
yarn.resourcemanager.hostname=13.com
# 日志聚集
yarn.log-aggregation-enable=true
yarn.log-aggregation.retain-seconds=604800

# mapred-site.xml
mapreduce.framework.name=yarn
# 历史服务器
mapreduce.jobhistory.address=12.com:10020
mapreduce.jobhistory.webapp.address=12.com:19888
```

***网页只显示一个 datanode，因为主机名相同***

*`etc/hadoop/slaves`*

```ini
11.com
12.com
13.com
```

## 启动命令

```bash
bin/hdfs
	namenode -format # 格式化
	dfsadmin -refreshNodes # 刷新

bin/yarn
	rmadmin -refreshNodes # 刷新

sbin/hadoop-daemon.sh start
	namenode
	datanode
	secondarynamenode

sbin/yarn-daemon.sh start
	nodenamager
	resourcemanager

sbin/mr-jobhistory-daemon.sh start
	historyserver

sbin/start-dfs.sh
sbin/start-yarn.sh
```

```bash
#!/bin/bash

if (($# != 1)); then
  echo "usage: myhadoop:start|stop"
  exit 1
fi
case $1 in
"start")
  ssh 11.com "start-dfs.sh"
  ssh 13.com "start-yarn.sh"
  ssh 12.com "mr-jobhistory-daemon.sh start historyserver"
  ;;
"stop")
  ssh 12.com "mr-jobhistory-daemon.sh stop historyserver"
  ssh 13.com "stop-yarn.sh"
  ssh 11.com "stop-dfs.sh"
  ;;
*)
  echo "require: start|stop"
  ;;
esac
```

## 默认端口

```ini
# 前台
namenode=50070
yarn=8088
```

## HDFS

- 块大小默认 128 M

```bash
hadoop fs | hdfs dfs
-put 本地 远程
-get 远程 本地
-getMerge 远程 本地 # /* a.txt
-moveFromLocal 本地 远程
-appendToFile 本地 远程
-setRep 远程 # 设置副本数量
```

### Fsimages 和 Edits

```bash
dfs.namenode.checkpoint.period=3600 # 每小时触发一次检查点
dfs.namenode.checkpoint.check.period=60 # 每隔一分钟判断次数
dfs.namenode.checkpoint.txns # 到达这么多次直接触发检查点


hdfs oiv -p XML -i fsimage_00 -o fsiamge.xml
hdfs oev -p XML -i edits_00 -o edits.xml
```

## mapreduce

- https://hadoop.apache.org/docs/r2.10.0/hadoop-mapreduce-client/hadoop-mapreduce-client-core/MapReduceTutorial.html#Source_Code

```java
// 序列化接口
interface Writable;
// 切片，kv
interface InputFormat<K, V> {
	InputSplit[] getSplits(JobConf job, int numSplits);
  RecordReader<K, V> getRecordReader(InputSplit split, JobConf job, Reporter reporter) 
}
// 分区
class HashPartitioner;
```

