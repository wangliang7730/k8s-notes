# Servlet

## web 目录结构

```text
├─build
│  └─classes
├─src
└─WebContent
    ├─META-INF
    │      MANIFEST.MF
    └─WEB-INF
        |	     web.xml
        ├─classes
        └─lib
```

## web.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee
                      http://xmlns.jcp.org/xml/ns/javaee/web-app_3_1.xsd"
         version="3.1">

</web-app>
```

## Servlet 配置

> ***xml***

```xml
<servlet>
  <servlet-name>helloServlet</servlet-name>
  <servlet-class>sharon.lee.learning.servlet.HelloServlet</servlet-class>
  <!-- 默认-1，懒加载，非负启动时加载  -->
  <load-on-startup>-1</load-on-startup>
</servlet>
<servlet-mapping>
  <servlet-name>helloServlet</servlet-name>
  <!-- 需要斜杠开头 -->
  <url-pattern>/hello</url-pattern>
</servlet-mapping>
```

> ***注解***

```java
@WebServlet
```

## Sevlet 生命周期

```java
@Override
public void init(ServletConfig servletConfig) throws ServletException {
  // 启动时执行一次
}

@Override
public void service(ServletRequest servletRequest, ServletResponse servletResponse) throws ServletException, IOException {
  // 每次访问执行
}

@Override
public void destroy() {
  // 关闭时执行一次
}
```


## 上下文：ServletContext

```java
// 获取路径
getContextPath();
// 保存设置数据
set/getAttribute();
// 获取真实路径
getRealPath();
// 获取 mime 类型
getMimeType();
// 获取配置
getInitParameter();
getInitParameterNames()
```

> ***xml***

```xml
<context-param>
  <param-name>foo</param-name>
  <param-value>bar</param-value>
</context-param>
```


## 配置：ServletConfig

```java
// 获取 config，init 里面记得 super.init(config);
servlet.getServletConfig();
// 获取 servlet 名字
getServletName();
// 获取 context
getServletContext();
// 获取初始化参数
getInitParameter();
getInitParameterNames();
```

> ***xml***

```xml
<servlet>
  <servlet-name>helloServlet</servlet-name>
  <servlet-class>sharon.lee.learning.servlet.HelloServlet</servlet-class>
  <init-param>
    <param-name>foo</param-name>
    <param-value>bar</param-value>
  </init-param>
  <init-param>
    <param-name>bar</param-name>
    <param-value>foo</param-value>
  </init-param>
</servlet>
```

## 请求：HttpServletRequest

```java
// 请求路径相关
getRequestURI() = /servlet/requestGetMethod;
getRequestURL() = http://localhost:9080/servlet/requestGetMethod;
getRemoteAddr() = 0:0:0:0:0:0:0:1;
getRemoteHost() = 0:0:0:0:0:0:0:1;
getRemotePort() = 12721;
getLocalPort() = 9080;
getServerPort() = 9080;
getLocalAddr() = 0:0:0:0:0:0:0:1;
getLocalName() = 0:0:0:0:0:0:0:1;
getServerName() = localhost;
getMethod() = GET;
getScheme() = http;
getProtocol() = HTTP/1.1;
getServletPath() = /requestGetMethod;
getContextPath() = /servlet;
// 请求参数相关
getParameterNames() = java.util.Collections$3@21b030fe;
getParameterMap() = org.apache.catalina.util.ParameterMap@7617590;
getCharacterEncoding() = null;
getCookies() = [Ljavax.servlet.http.Cookie;@6c79092e;
getSession() = org.apache.catalina.session.StandardSessionFacade@317299e8;
getRequestedSessionId() = 7D42B726512F936130C3675CA72BF84C;
getHeaderNames() = org.apache.tomcat.util.http.NamesEnumerator@6e777cad;
getQueryString() = null;
getContentLength() = -1;
getContentLengthLong() = -1;
getContentType() = null;
// Servlet 支持
getAttributeNames() = java.util.Collections$3@2bf53959;
getServletContext() = org.apache.catalina.core.ApplicationContextFacade@1e3f0e3c;
getDispatcherType() = REQUEST;
```

## 请求转发：RequestDispatcher

```java
// requst.getRequestDispatcher("/foo");
forward();
include();
```

## 响应：HTTPServletResponse

```java
getWriter();
getOutputStream();
setStatus();
setHeader();
setContentType();
sendRedirect();
```

# JDBC

## 参数

```java
// 批量发送
rewriteBatchedStatements=true;
// 编码
characterEncoding=UTF-8;
```

