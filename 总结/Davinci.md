# Davinci

- Github：https://github.com/edp963/davinci
- Gitee：https://gitee.com/mirrors/Davinci
- 官方文档：https://edp963.github.io/davinci/

## 目标



## 源码启动

- 下载[RELEASE](https://github.com/edp963/davinci/releases)，拷贝 `davinci-ui` 到项目根目录
- 指定环境变量 `DAVINCI3_HOME` 或 `java -DDAVINCI3_HOME` 指向项目根目录
- 拷贝 `application.yml.example` 为 `application.yml`
- 具体配置参考官网

## 邮箱配置

```yaml
  mail:
    host: smtp.exmail.qq.com
    port: 465
    username: lixr@novasoftware.cn
    fromAddress:
    password: Nova123
    nickname:

    properties:
      smtp:
        starttls:
          enable: true
          required: true
        auth: true
      mail:
        smtp:
          ssl:
            enable: true
```

## 错误处理

### java: 程序包com.sun.tools.javac.util不存在

添加 tools.jar 到 lib

### dataSource already closed at Wed May 12 11:01:44 CST 2021

没有配置邮箱