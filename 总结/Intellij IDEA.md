# Intellij IDEA

## 激活

```
-javaagent:C:\Users\sharon\.jetbrains\jetbrains-agent-v3.0.0.jar
http://fls.jetbrains-agent.com
```

## 常用设置

### 设置代码模板

```java
/**
* @author lixiaorong
* Email: lixr@novasoftware.cn
* Create: ${YEAR}-${MONTH}-${DAY} ${TIME}
*/
```

### JUnit 允许控制台输入

```ini
-Deditable.java.test.console=true
```

### 启用 Run DashBoard

```ini
-Dide.run.dashboard=true
```

### JavaScript 不检查分号

`File | Settings | Editor | Code Style | JavaScript | `

![image-20200924220806547](.\media\image-20200924220806547.png)

## 插件

### Jrebel

- https://jrebel.qekang.com/

- https://www.guidgen.com/

### actiBPM

- https://plugins.jetbrains.com/plugin/7429-actibpm/versions

## Failed to retrieve application JMX service URL

- https://youtrack.jetbrains.com/issue/IDEA-210665

删除 `%TMP%/hsperfdata_<username>`，自动重新创建就好了

## Lombok 问题

> java: You aren't using a compiler supported by lombok, so lombok will not work and has been disabled.
> Your processor is: com.sun.proxy.$Proxy32
> Lombok supports: OpenJDK javac, ECJ

- https://github.com/projectlombok/lombok/issues/2592#
- provided
- -Djps.track.ap.dependencies=false

## 反编译

- https://stackoverflow.com/questions/28389006/how-to-decompile-to-java-files-intellij-idea
- https://github.com/JetBrains/intellij-community/tree/master/plugins/java-decompiler/engine

```shell
"C:\Program Files\JetBrains\IntelliJ IDEA 2021.1.3\jbr\bin\java" -cp "C:\Program Files\JetBrains\IntelliJ IDEA 2021.1.3\plugins\java-decompiler\lib\java-decompiler.jar" org.jetbrains.java.decompiler.main.decompiler.ConsoleDecompiler -dgs
```

## Adress already in use

https://intellij-support.jetbrains.com/hc/en-us/community/posts/360004973960-Critical-Internal-Error-on-Startup-of-IntelliJ-IDEA-Cannot-Lock-System-Folders-

```shell
Get-NetAdapter | Disable-NetAdapter -Confirm:$false -PassThru:$true | Enable-NetAdapter
```

