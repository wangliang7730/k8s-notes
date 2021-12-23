# Elasticsearch

## 安装 Elasticsearch

版本兼容：https://www.elastic.co/cn/support/matrix#matrix_compatibility

### Docker 方式安装

```bash
docker pull elasticsearch:7.6.2
docker run -d --name es -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" elasticsearch:7.6.2
```

访问：http://localhost:9200

### 启动

```yaml
docker exec -it es /bin/bash
cd config
vi elasticsearch.yml

# 配置
http.cors.enabled: true
http.cors.allow-origin: "*"

# 重启
docker restart es
```

## 安装 Elasticsearch Head

```bash
docker pull mobzelasticsearch-head:5
docker run -d --name es-head -p 9100:9100 docker.io/mobz/elasticsearch-head:5
```

访问：http://localhost:9100

>   需要允许 Elasticsearch 跨域

### 406 错误

```bash
docker exec -it es-head /bin/bash
# 没有vi，拷贝出来改
docker cp es-head:/usr/src/app/_site/vendor.js /tmp/vendor.js
vi /tmp/vendor.js
# x-www-form-urlencoded 替换为 json;charset=UTF-8
:s/x-www-form-urlencoded/json;charset=UTF-8/g
# 拷贝回去
docker cp /tmp/vendor.js es-head:/usr/src/app/_site/vendor.js
# 重启
docker restart es-head
```

## 安装 Kibana

```bash
docker pull kibana:7.6.2
docker run -d --name kibana --link es:elasticsearch -p 5601:5601 kibana:7.6.2
```

访问：http://localhost:5601

### 配置中文

```bash
docker exec -it kibana /bin/bash
cd config
vi kibana.yml

# 增加
i18n.locale: "zh-CN"

# 重启
docker restart kibana
```

## 安装 IK 分词器

github 地址：https://github.com/medcl/elasticsearch-analysis-ik

### 方式一

```bash
docker exec -it es /bin/bash
cd plugins
elasticsearch-plugin install https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v7.6.2/elasticsearch-analysis-ik-7.6.2.zip
docker restart es
```

### 方式二

```bash
cd plugins && mkdir ik && cd ik
curl -LJO https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v7.6.2/elasticsearch-analysis-ik-7.6.2.zip
# 加速 curl -LJO https://hub.fastgit.org/medcl/elasticsearch-analysis-ik/releases/download/v7.6.2/elasticsearch-analysis-ik-7.6.2.zip
unzip elasticsearch-analysis-ik-7.6.2.zip
```

### 添加字典

```bash
#docker exec -it -e LANG=C.UTF-8 es /bin/bash
docker exec -it es /bin/bash
# elasticsearch-plugin 方式安装配置文件在
cd config/analysis-ik
# 手动解压配置文件在
cd plugins/ik/config
# 中文乱码不管，也可以添加成功
vi my.dic
vi IKAnalyzer.cfg.xml
# 添加
<entry key="ext_dict">my.dic</entry>
docker restart es
```

### 测试

```json
GET _analyze
{
  "analyzer": "ik_smart",
  "text": "黎小荣"
}
```

分词方式：有 `ik_smart` 和 `ik_max_word` 两种

## 和 MySQL 概念对比

| MySQL         | Elasticsearch |
| -------- | ------------- |
| Database | Index         |
| Table    | Type          |
| Row      | Document      |
| Column   | Field         |
| Schema   | Mapping       |
| Index | Everything is indexed |
| SQL | Query DSL |
| SELECT * FROM table ... | GET http://... |
| UPDATE table SET ... | PUT http://... |

## 参考

- [docker安装elasticsearch和kibana](https://www.cnblogs.com/adawoo/p/12455265.html)