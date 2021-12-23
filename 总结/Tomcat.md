# Tomcat

## 部署的几种方式

### 放在 webapps 文件夹下

- 访问路径就是文件夹名
- 放 war 包自动部署，删除 war 包自动卸载

### 配置 Context

*`conf/server.xml`*

```xml
<Context docBase="文件夹路径" path="访问路径"/>
```

### Catalina 文件夹下配置

*`conf/Catalina/localhost/访问路径.xml`*

```xml
<Context docBase="文件夹路径"/>
```

## Intellij IDEA 中乱码

*`~\.IntelliJIdea2019.2\config\idea64.exe.vmoptions`*，tomcat 启动参数中

```text
-Dfile.encoding=UTF-8
```

## 重复部署问题

https://www.jianshu.com/p/58c708cb324d