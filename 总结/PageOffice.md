# PageOffice

## 注册

### 在线注册

填写信息，直接点击注册，会在 *WEB-INF/lib* 目录下生成 *license.lic*

### 离线注册

1. pageOffice 客户端软件中输入注册信息，生成 txt 文件
2. 到[这里](http://www.zhuozhengsoft.com/po/reg.aspx)输入 txt 文件中的内容注册
3. 下载得到 *license.lic*
4. 拷贝 *license.lic* 到 *WEB-INF/lib* 下

## [官方示例](http://www.zhuozhengsoft.com/dowm/)

### 搭建项目

结合官方文档说明，为了学习方便建立一个 maven webapp 项目

1. 拷贝 *Samples5* 中的内容到 *webapp* 目录下
2. 配置 pom 文件

```xml
<?xml version="1.0" encoding="UTF-8"?>

<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>sharon.lee</groupId>
    <artifactId>pageoffice-samples</artifactId>
    <version>1.0-SNAPSHOT</version>
    <packaging>war</packaging>

    <dependencies>
        <dependency>
            <groupId>com.zhuozhengsoft</groupId>
            <artifactId>pageoffice</artifactId>
            <scope>system</scope>
            <systemPath>${project.basedir}/src/main/webapp/WEB-INF/lib/pageoffice5.2.0.6.jar</systemPath>
        </dependency>
        <dependency>
            <groupId>javax.servlet</groupId>
            <artifactId>servlet-api</artifactId>
            <version>2.5</version>
            <scope>provided</scope>
        </dependency>
        <dependency>
            <groupId>javax.servlet.jsp</groupId>
            <artifactId>jsp-api</artifactId>
            <version>2.2</version>
            <scope>provided</scope>
        </dependency>
    </dependencies>

</project>
```

> jsp 文件中 `this.getServletContext()` 会报错，Servlet 标准不支持，Tomcat 才支持，替换为 `this.getServletConfig().getServletContext()`

## jar 包添加到本地仓库

```bash
mvn install:install-file -DgroupId=com.zhuozhengsoft -DartifactId=pageoffice -Dversion=5.1.0.1  -Dpackaging=jar  -Dfile=pageoffice5.1.0.1.jar
```

```xml
<dependency>
		<groupId>com.zhuozhengsoft</groupId>
		<artifactId>pageoffice</artifactId>
		<version>5.1.0.1</version>
</dependency>
```

## 基本使用

- 创建 `PageOfficeCtrl`，读取文档，设置属性

```java
PageOfficeCtrl poCtrl = new PageOfficeCtrl(request);
//设置服务器页面
poCtrl.setServerPage(request.getContextPath() + "/poserver.zz");
//添加自定义按钮
poCtrl.addCustomToolButton("保存", "Save", 1);
poCtrl.addCustomToolButton("打印设置", "PrintSet", 0);
poCtrl.addCustomToolButton("打印", "PrintFile", 6);
poCtrl.addCustomToolButton("全屏/还原", "IsFullScreen", 4);
poCtrl.addCustomToolButton("-", "", 0);
poCtrl.addCustomToolButton("关闭", "Close", 21);
//设置保存页面
poCtrl.setSaveFilePage("SaveFile.jsp");
//打开Word文档
poCtrl.webOpen("doc/test.doc", OpenModeType.docNormalEdit, "张佚名");
```

- 使用 `poCtrl.getHtmlCode("PageOfficeCtrl1")` 获取指定 id 的 html，嵌入到网页中
- ie 可以网页直接打开，其他浏览器需要 js 调用 `POBrowser.openWindowModeless('SimpleWord/Word.jsp')` 唤起本地 POBrowser 程序打开

## 保存文件

```java
FileSaver fs = new FileSaver(request, response);
fs.saveToFile(request.getSession().getServletContext().getRealPath("SimpleWord/doc/") + "/" + fs.getFileName());
fs.close();
```

## DataTag 赋值

```java
//定义WordDocument对象
WordDocument doc = new WordDocument();

//定义DataTag对象
DataTag deptTag = doc.openDataTag("{部门名}");
deptTag.setValue("技术");

pCtrl.setWriter(doc);
```

## DataRegion 赋值

```java
WordDocument doc = new WordDocument();
//打开数据区域
DataRegion dataRegion1 = doc.openDataRegion("PO_userName");
//给数据区域赋值
dataRegion1.setValue("张三");
poCtrl1.setWriter(doc);
```

## FileMaker

```java
FileMakerCtrl fmCtrl = new FileMakerCtrl(request);
fmCtrl.setServerPage(request.getContextPath() + "/poserver.zz");
WordDocument doc = new WordDocument();
//禁用右击事件
doc.setDisableWindowRightClick(true);
//给数据区域赋值，即把数据填充到模板中相应的位置
doc.openDataRegion("PO_company").setValue("北京卓正志远软件有限公司  ");
fmCtrl.setSaveFilePage("SaveMaker.jsp");
fmCtrl.setWriter(doc);
fmCtrl.setJsFunction_OnProgressComplete("OnProgressComplete()");
fmCtrl.setFileTitle("newfilename.doc");
fmCtrl.fillDocument("doc/template.doc", DocumentOpenType.Word);
```

