# XML

## 头

```xml
<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<!-- 引入 css 指令 -->
<?xml-stylesheet type="text/css" href="a.css"?>
```

## CDATA

```xml
<![CDATA[
	Unparsed Character Data
]]>
```

## DTD

### 引入

```xml
<!-- 引入内部 -->
<!DOCTYPE 根元素 [元素声明]>
<!-- 引入本地 -->
<!DOCTYPE 根元素 SYSTEM "文件路径">
<!-- 引入网络 -->
<!DOCTYPE 根元素 PUBLIC "文件名" "文件URL">
```

## XSD

### 引入

```xml
<根元素 xmlns="根元素名称空间"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:o="other-schema"
xsi:schemaLocation="other-schema other-schema.xsd">
```