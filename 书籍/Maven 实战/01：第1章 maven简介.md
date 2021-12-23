---
date: 2021-09-29
updated: 2021-12-19
---

# 第1章 Maven 简介

## 1.1 何为 Maven

Maven 这个词可以翻译为**“知识的积累”**，也可以翻译为**“专家”**或**“内行”**。

### 1.1.1 何为构建

除了编写源代码，我们每天有相当一部分时间花在了编译、运行单元测试、生成文档、打包和部署等烦琐且不起眼的工作上，这就是构建。

### 1.1.2 Maven 是优秀的构建工具

Maven 作为一个构建工具，不仅能帮我们**自动化构建**，还能够**抽象构建过程**，提供构建任务实现；它**跨平台**，对外提供了一致的操作接口，这一切足以使它成为优秀的、流行的构建工具。

### 1.1.3 Maven 不仅仅是构建工具

Maven 不仅是构建工具，还是一个**依赖管理工具**和**项目信息管理工具**。它提供了中央仓库，能帮我们自动下载构件。

使用 Maven 还能享受一个额外的好处，即 Maven 对于项目目录结构、测试用例命名方式等内容都有既定的规则，约定优于配置（Convention Over Configuration）。

## 1.2 为什么需要 Maven

### 1.2.1 组装 PC 和品牌 PC

使用 Maven 就像购买品牌 PC，省时省力，并能得到成熟的构建系统，还能得到来自于 Maven 社区的大量支持，并且开源、免费。

### 1.2.2 IDE 不是万能的

IDE 有天生缺陷：

- **IDE 依赖大量的手工操作：** 编译、测试、代码生成等工作都是相互独立的，很难一键完成所有工作。
- **很难在项目中统一所有的 IDE 配置：** 每个人都有自己的喜好，在机器 A 上可以成功运行的任务，到了机器 B 的 IDE 中可能会失败。

### 1.2.3 Make

Make 由一个名为 Makefile 的脚本文件驱动，由一系列规则（Rules）组成，每一条规则包括了目标（Target）、依赖（Prerequisite）和命令（Command）。Makefile 的基本结构如下：

```makefile
TARGET... : PREREQUISITE...
	COMMAND
	...
	...
```

Make 将自己和操作系统绑定在一起了，不能实现（至少**很难**）**跨平台**的构建。此外，很多人抱怨 Make 构建失败的原因往往是一个难以发现的空格或 Tab 使用错误。

### 1.2.4 Ant

“另一个整洁的工具”（Another Neat Tool）最早用来构建著名的 Tomcat，动机就是受不了 Makefile 的语法格式。可以将 **Ant 看成 Java 版本的 Make**。

与 Make 类似，Ant 有一个构建脚本 build.xml，如下所示：

```xml
<?xml version = "1.0"?> .
<project name="Hello" default="compile">
    <target name="compile" description="compile the Java source code to classfiles">
        <mkdir dir="classes"/>
        <javac srcdir="." destdir="classes"/>
    </target>
    <target name="jar" depends="compile" description="create a Jar file">
        <jar destfile="hello.jar">
            <fileset dir="classes" includes="**/*.class"/>
            <manifest>
                <attribute name="Main-Class" value="HelloProgram"/>
            </manifest>
        </jar>
    </target>
</project>
```

Ant 的没有依赖管理的，不过现在可以借助 Ivy 管理依赖。

### 1.2.5 不重复发明轮子

Maven 比“规范化 Ant 强大”，已经有一大把现成的插件，全世界都在用，你自己不用写任何代码。

为什么没有人说“我自己写的代码最灵活，所以我不用 Spring，我自己实现 IOC；我不用 Hibernate，我自己封装 JDBC”？

## 1.3 Maven 与极限编程

Maven 对极限编程（ExtremeProgramming，XP）的帮助：

- **简单**
- **交流与反馈**
- **测试驱动开发（TDD）**
- **十分钟构建**
- **持续集成（CI）**
- **富有信息的工作区**

> 极限编程（ExtremeProgramming，简称XP）是由KentBeck在1996年提出的，是一种[软件工程](https://baike.baidu.com/item/软件工程/16352442)方法学，是[敏捷软件开发](https://baike.baidu.com/item/敏捷软件开发/7108658)中可能是最富有成效的几种方法学之一。如同其他敏捷方法学，极限编程和传统方法学的本质不同在于它更强调可适应性能性以及面临的困难。1996年三月，Kent终于在为DaimlerChrysler所做的一个项目中引入了新的软件开发观念——XP。适用于小团队开发。    ——百度百科

## 1.4 被误解的 Maven

>  “只有两类计算机语言，一类语言天天被人骂，还有一类没人用。”   ——Bjarne Stroustrup（C++ 之父）

Maven 受到的质疑：

- Maven 对于 IDE（如 Eclipse 和 IDEA）的支持较差，bug 多，而且不稳定。
- Maven 采用了一个糟糕的插件系统来执行构建，新的、破损的插件会让你的构建莫名其妙地失败。
- Maven 过于复杂，它就是构建系统的 EJB2。
- Maven 的仓库十分混乱，当无法从仓库中得到需要的类库时，我需要手工下载复制到本地仓库中。
- 缺乏文档是理解和使用 Maven 的一个主要障碍！

## 1.5 小结

略。
