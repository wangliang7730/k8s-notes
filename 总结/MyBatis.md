# MyBatis

## 属性

### 默认值

```xml
<properties resource="类路径文件" url="">
  <!-- 开启默认值解析，默认false -->
  <property name="org.apache.ibatis.parsing.PropertyParser.enable-default-value" value="true"/>
  <!-- 修改默认值的分隔符，默认: -->
  <property name="org.apache.ibatis.parsing.PropertyParser.default-value-separator" value="?:"/>
  <property name="变量名" value="变量值:默认值"/>
</properties>
```

### 优先级

属性优先级如下：

1.  properties 元素中指定的属性
2.  resource/url 指定的文件
3.  程序传 Properties 类

