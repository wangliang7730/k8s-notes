---
date: 2021-09-29
updated: 2021-12-20
---

# 第2章 Maven的安装和配置

## 2.1 在 Windows 上安装 Maven

### 2.1.1 检查 JDK 安装

```shell
echo %JAVA_HOME%
java -version
```

### 2.1.2 下载 Maven

下载页面：http://maven.apache.org/download.html。

### 2.1.3 本地安装

设置环境变量 `M2_HOME`，Path 中增加 `%M2_HOME%\bin`。检查 Maven 安装情况：

```shell
echo %M2_HOME%
mvn -v
```

### 2.1.4 升级 Maven

解压新的 Maven 安装文件后，更新 `M2_HOME` 环境变量即可。

## 2.2 在基于unix的系统上安装maven

### 2.2.1 下载和安装

检查 Java 环境：

```shell
echo $JAVA_HOME
java -version
```

解压、创建软连接：

```shell
tar -zxvf apache-maven-3.0-bin.tar.gz
ln -s apache-maven-3.0 apache-maven
```

添加环境变量：

`~/.bashrc`

```shell
export M2_HOME=/home/juven/bin/apache-maven
export PATH=$PATH:$M2_HOME/bin
```

检查安装：

```shell
echo $M2_HOME
mvn -v
```

### 2.2.2 升级maven

更新符号链接即可：

```shell
rm apache-maven
ln -s apache-maven-3.1 /apache-maven
```

## 2.3 安装目录分析

### 2.3.1 M2_HOME

-   `bin`：包含了 `mvn`（mvn.bat）、`mvnDebug`（mvnDebug.bat）和 `m2.conf`（classworlds 的配置文件）。
-   `boot`：只有 `plexus-classworlds-2.5.2.jar`，是一个类加载框架，相对于默认的 java 类加载器，提供了更丰富的语法以方便配置。更多关于 classwords 的信息请参考 ~~http://classwords.codehaus.org/~~（https://codehaus-plexus.github.io/plexus-classworlds/）。
-   `conf`：包含了重要的配置文件 `settings.xml`，建议复制到 `~/.m2/` 目录下修改。
-   `lib`：包含了所有 Maven 运行时需要的类库。

### 2.3.2 ~/.m2

打印所有的 Java 系统属性和环境变量：

```shell
mvn help:system
```

默认情况下，`~/.m2` 目录下放置了 Maven 本地仓库 `repository`。大多数 Maven 用户需要复制 `M2_HOME/conf/settings.xml` 文件到 `~/.m2/setting.xml`，这是一条最佳实践。

## 2.4 设置http代理

有时候公司基于安全因素考虑，要求使用通过安全认证的代理访问因特网：

`~/.m2/settings.xml`

```xml
<settings>
    ...
    <proxies>
        <proxy>
            <id>my-proxy</id>
            <active>true</active>
            <protocol>http</protocol>
            <host>218.14.227.197</host>
            <port>3128</port>
            <!--
            <username>***</username>
            <password>***</password>
            <nonProxyHosts>repository.mycom.com|*.google.com<nonProxyHosts>
            -->
        </proxy>
    </proxies>
    ...
</settings>
```

- `active`：表示代理激活。
- `protocol`：代理协议。
- `host`、`port`：主机、端口。
- `username`、`password`：认证信息。
- `nonProxyHosts`：哪些主机名不需要代理。可以用 `|` 分割多个主机名，`*` 是通配符。

## 2.5 安装 m2eclipse

略。

## 2.6 安装 Netbeans Maven 插件

略。

## 2.7 Maven 安装最佳实践

### 2.7.1 设置 MAVEN_OPTS 环境变量

可以设置 `MAVEN_OPTS` 环境变量指定 Maven 启动的 Java 选项，如：`-Xms128m -Xmx512m`。

尽量不要直接修改 `mvn.bat` 或 `mvn`，也尽可能不去修改任何 Maven 安全目录下的文件，因为升级 Maven 时不得不再次修改，一来麻烦，二来容易忘记。

### 2.7.2 配置用户范围 settings.xml

`M2_HOME/conf/settings.xml` 是全局范围的，`~/.m2/settings.xml` 是用户范围的。推荐使用用户范围的 `settings.xml`：

- 避免无意识地影响到系统中的其他用户。
- 便于升级。

### 2.7.3 不要使用 IDEA 内嵌的 Maven

- 不一定很稳定。
- 如果和使用命令行时的 Maven 不是同一个版本，容易造成构建行为不一致。

## 2.8 小结

略。
