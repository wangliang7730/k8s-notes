# Maven

```bash
# 跳过测试
-Dmaven.test.skip=true
# 跳过证书检查
-Dmaven.wagon.http.ssl.insecure=true -Dmaven.wagon.http.ssl.allowall=true
```

## 常用设置

```xml
<!-- 阿里镜像 -->
<mirror>
  <id>aliyunmaven</id>
  <mirrorOf>central</mirrorOf>
  <name>aliyunmaven</name>
  <url>https://maven.aliyun.com/repository/public</url>
</mirror>

<!-- 默认 profile -->
<profile>
  <id>default</id>
  <activation>
    <activeByDefault>true</activeByDefault>
  </activation>
  <properties>
    <maven.compiler.source>1.8</maven.compiler.source>
    <maven.compiler.target>1.8</maven.compiler.target>
    <maven.compiler.compilerVersion>1.8</maven.compiler.compilerVersion>
    <maven.test.skip>true</maven.test.skip>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
  </properties>
</profile>
```

## 安装本地 jar 包

```shell
mvn install:install-file -DgroupId=com.zhuozhengsoft -DartifactId=pageoffice -Dversion=5.0.0.11 -Dpackaging=jar -Dfile=C:\Users\sharon\Downloads\pageoffice5.1.0.2.jar
```

## SpringBoot 打入本地包

```xml
<plugin>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-maven-plugin</artifactId>
  <configuration>
    <includeSystemScope>true</includeSystemScope>
  </configuration>
</plugin>
```

## Docker 插件

```xml
<plugin>
  <groupId>com.spotify</groupId>
  <artifactId>docker-maven-plugin</artifactId>
  <version>1.2.2</version>
  <configuration>
    <imageName>${project.artifactId}</imageName>
    <imageTags>
      <imageTag>${project.version}</imageTag>
    </imageTags>
    <dockerDirectory>src/main/docker</dockerDirectory>
    <dockerHost>http://10.10.120.26:2375</dockerHost>
    <resources>
      <resource>
        <targetPath>/</targetPath>
        <directory>${project.build.directory}</directory>
        <include>${project.build.finalName}.jar</include>
      </resource>
    </resources>
  </configuration>
</plugin>
```

## 多模块打包

```shell
mvn package -pl fold -am
mvn package -pl :artifactId -am
-pl, --projects
        Build specified reactor projects instead of all projects
-am, --also-make
        If project list is specified, also build projects required by the list
```

## 获取版本信息

```shell
mvn help:evaluate -Dexpression=project.version -q -DforceStdout
mvn org.apache.maven.plugins:maven-help-plugin:3.2.0:evaluate -Dexpression=project.version -q -DforceStdout
mvn -q -Dexec.executable="echo" -Dexec.args='${project.version}' --non-recursive exec:exec
```

