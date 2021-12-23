---
date: 2021-06-30
updated: 2021-12-11
---

# Windows 开发环境搭建

## 备份

- Maven 仓库（节省时间）。
- 代码仓库（节省时间，防数据丢失（可能有未提交的代码））。
- QQ、微信和企业微信聊天记录（方便工作）。
- Navicat 和 XShell 连接信息（方便工作）。
- 工作资料（方便工作，防数据丢失）。

## 常用软件

**[Windows 常用软件思维导图](https://naotu.baidu.com/file/6172d9741720318eb958e2dff8f0cc91)**

![Windows 常用软件](assets/Windows 常用软件-16398524689572.svg)

## v2rayN

- 下载：[Github](https://github.com/2dust/v2rayN/releases/download/3.29/v2rayN-Core.zip) | [Fastgit](https://hub.fastgit.org/2dust/v2rayN/releases/download/3.29/v2rayN-Core.zip) | [百度网盘](https://pan.baidu.com/disk/home?_at_=1639215193920#/all?vmode=list&path=%2FSoftware%2Fv2rayN)。
- 配置：[语雀](https://www.yuque.com/inception-hrbgu/dwrghm/prfm4p)。

## [Notepad++](https://pan.baidu.com/disk/home?_at_=1639215193920#/all?vmode=list&path=%2FSoftware%2Fv2rayN)

- 下载：[Github](https://github.com/notepad-plus-plus/notepad-plus-plus/releases) | [Fastgit](https://hub.fastgit.org/notepad-plus-plus/notepad-plus-plus/releases) | [SourceForge](https://sourceforge.net/projects/notepadplusplus.mirror/)。
- 显示符号：`视图|显示符号|显示空格与制表符`
- 制表符：`设置|首选项|语言|替换为空格`

## Git

- 下载：[淘宝镜像](http://npm.taobao.org/mirrors/git-for-windows/)。
- 密钥：[语雀](https://www.yuque.com/inception-hrbgu/dwrghm/prfm4p)。
- 配置：

  ```shell
  git config --global user.name lixiaorong
  git config --global user.email 320019345@qq.com
  git config --global alias.ca "!git add -A && git commit -a --allow-empty-message -m """""
  # Linux
  # git config --global alias.ca '!git add -A && git commit -a --allow-empty-message -m ""'
  ```

> **注意：**
>
> Linux 中需要使用 Linux 换行符，并设置以下权限：
>
> ```shell
> chmod 755 ~/.ssh/  
> chmod 600 ~/.ssh/id_rsa ~/.ssh/id_rsa.pub   
> chmod 644 ~/.ssh/known_hosts  
> ```

## Typora

- 设置快捷键：编辑文件夹 `%HOMEDRIVE%%HOMEPATH%\AppData\Roaming\Typora\conf` 中文件 `conf.user.json`：

    ```json
    "keyBinding": {
        "code": "Ctrl+`"
    },
    ```
    
- 主题：去文件夹 `%HOMEDRIVE%%HOMEPATH%\AppData\Roaming\Typora\themes` 克隆：

    ```shell
    git clone https://github.com/blinkfox/typora-vue-theme.git
    ```

- 打开指定目录。
- 自动保存。
- 不使用拼写检查。
- 图片复制到指定路径 `./assets`，优先使用相对路径。
- 代码缩进 2

## JDK

- 下载：[华为镜像](https://mirrors.huaweicloud.com/java/jdk/8u202-b08/) | [OpenJDK8](http://jdk.java.net/java-se-ri/8-MR3) | [AdoptOpenJDK](https://adoptopenjdk.net/)。

## Maven

- 下载：[华为镜像](https://repo.huaweicloud.com/apache/maven/maven-3/3.6.0/)。

- 配置：`settings.xml`

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

## Intellij IDEA

**激活：**

- [Jetbrains系列产品重置试用方法](https://zhile.io/2020/11/18/jetbrains-eval-reset-da33a93d.html)。

- Eval Reset 仓库地址：https://plugins.zhile.io。

**插件：**

- Free Mybatis Plugin。

- MyBatis Log：[git](https://github.com/Link-Kou/intellij-mybaitslog)、[download](https://raw.githubusercontent.com/Link-Kou/intellij-mybaitslog/master/plugin/plugin.intellij.assistant.mybaitslog-2.0.2.jar)。

- Jrebel：https://jrebel.qekang.com

  https://jrebel.qekang.com/41302f0e-000a-474b-835b-11ec127de5ef

- CodeGlance。

- CamelCase。

- Alibaba Java Coding。

**设置：**

- 不启动上次项目。

- 自动导入。

- 关闭 Reader Mode。

- 显示空白字符。

- 代码提示、显示文档。

- Tab 多行。

- 字体。

- File Header

  ```java
  /**
   * @author lixiaorong ${DATE} ${TIME}
   */
  ```
  
- 编码。

- maven。

## VSCode

- 下载地址：https://az764295.vo.msecnd.net/stable/c3f126316369cd610563c75b1b1725e0679adfb3/VSCodeUserSetup-x64-1.58.2.exe
- 加速：https://vscode.cdn.azure.cn/stable/c3f126316369cd610563c75b1b1725e0679adfb3/VSCodeUserSetup-x64-1.58.2.exe
- 不要打开上次窗口：`window.restoreWindows`

```shell
set-executionpolicy remotesigned
```

## Node

```shell
npm config set registry https://registry.npm.taobao.org
```

