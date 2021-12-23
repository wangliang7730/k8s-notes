## 拷贝

```shell
id=$(docker create image-name)
docker cp $id:/from /to
docker rm -v $id
```

## Elasticsearch

```shell
id=$(docker create elasticsearch:1.4)
docker cp $id:/etc/elasticsearch/elasticsearch.yml .
docker rm -v $id
```

```yaml
http.cors.enabled: true
http.cors.allow-origin: "*"
```

```yaml
version: '3'
services:
    elasticsearch:
        image: elasticsearch:1.4
        container_name: elasticsearch
        environment:
            - discovery.type=single-node
            - 'ES_JAVA_OPTS=-Xms512m -Xmx512m'
        volumes:
            - ./data:/usr/share/elasticsearch/data
            - ./plugins:/usr/share/elasticsearch/plugins
            - ./elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml
        ports:
            - '9200:9200'
            - '9300:9300'
```

