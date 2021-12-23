# FastDFS

## 安装

参考：https://github.com/happyfish100/fastdfs/wiki

```bash
yum install git gcc gcc-c++ make automake autoconf libtool pcre pcre-devel zlib zlib-devel openssl-devel wget vim -y
```

### 安装 libfatscommon

```bash
# 下载 https://github.com/happyfish100/libfastcommon/archive/V1.0.43.tar.gz
tar -zxvf libfastcommon-1.0.43.tar.gz
cd libfastcommon-1.0.43
./make.sh
./make.sh install
```

### 安装 FastDFS

```bash
# 下载 https://github.com/happyfish100/fastdfs/archive/V6.06.tar.gz
tar -xzvf fastdfs-6.06.tar.gz
cd fastdfs-6.06
./make.sh
./make.sh install

# 配置文件
cp /usr/local/fastdfs/fastdfs-6.06/conf/http.conf /etc/fdfs/
cp /usr/local/fastdfs/fastdfs-6.06/conf/mime.types /etc/fdfs/
```

### 安装 fastdfs-nginx-module

```bash
# 下载 https://github.com/happyfish100/fastdfs-nginx-module/archive/V1.22.tar.gz
tar -zxvf fastdfs-nginx-module-1.22.tar.gz
cp /usr/local/fastdfs/fastdfs-nginx-module-1.22/src/mod_fastdfs.conf /etc/fdfs/
# nginx 安装模块
./configure --add-module=/usr/local/fastdfs/fastdfs-nginx-module-1.22/src/
make
cp objs/nginx /usr/local/nginx/sbin/
```

### 单机部署

*`/etc/fdfs/tracker.conf`*

```ini
# cp /etc/fdfs/tracker.conf.sample /etc/fdfs/tracker.conf

port=22122
base_path=/home/fdfs
http.server_port=80 # 和 nginx 一致
```

*`/etc/fdfs/storage.conf`*

```ini
# cp /etc/fdfs/storage.conf.sample /etc/fdfs/storage.conf

port = 23000
base_path=/home/fdfs
store_path0=/home/fdfs
tracker_server=192.168.100.100:22122
http.server_port=80
```

*`/etc/fdfs/mod_fastdfs.conf`*

```ini
tracker_server=192.168.100.100:22122
url_have_group_name=true
store_path_count=1
store_path0=/home/fdfs
```

*`nginx.conf`*

```ini
server {
    listen       80;
    server_name  localhost;
    location ~/group[0-9] {
        ngx_fastdfs_module;
    }
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
    root   html;
    }
}
```

> ***启动***

```bash
service fdfs_trackerd start
service fdfs_storaged start
# 日志在 base_path/logs
/usr/local/nginx/sbin/nginx
```

### 测试

*`/etc/fdfs/client.conf`*

```ini
# cp /etc/fdfs/client.conf.sample /etc/fdfs/client.conf

base_path = /home/fdfs
tracker_server = 192.168.100.100:22122
```

```bash
/usr/bin/fdfs_upload_file /etc/fdfs/client.conf foo.png
/usr/bin/fdfs_test /etc/fdfs/client.conf upload img0.png 
```

## 报错

- ***tracker_query_storage fail, error no: 28, error info: No space left on device***

```ini
# etc/fdfs/tracker.conf
reserved_storage_space=1%
```

## java client

*`fdfs_client.conf`*

```ini
tracker_server = 192.168.100.100:22122
```

```java
ClientGlobal.init(ClassLoader.getSystemResource("fdfs_client.conf").getPath());
TrackerClient trackerClient = new TrackerClient();
TrackerServer trackerServer = null;
trackerServer = trackerClient.getConnection();
storageClient = new StorageClient(trackerServer, null);
storageClient.upload_file(bytes, ext, null);
```

