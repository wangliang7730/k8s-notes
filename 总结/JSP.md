# JSP

## 代码块

```html
<% service 方法内部 %> 或 <jsp:scriptlet>脚本</jsp:scriptlet>
<%! 类内部代码 %> 或 <jsp:declaration>声明</jsp:declaration>
<%= 调用out.print() %> 或 <jsp:expression>表达式</jsp:expression>
```

## 注释

```html
<!-- html 注释 -->
// java 代码注释
/* java代码注释 */
<%-- jsp 注释 --%>
```

## 指令

```html
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
        import="java.util.List"
        autoFlush="true"
        buffer="8kb"
        errorPage=""
        isErrorPage=""
        extends="" %>
<%@ include %>
<%@ taglib %>
```

## 行为

```xml
<jsp:include>
<jsp:useBean>
<jsp:setProperty>
<jsp:forward>
<jsp:plugin>
<jsp:attribute>
<jsp:body>
<jsp:text>
```

## 九大内置对象

- 四大域对象：pageContext、request、session、application

- 响应：response
- this：page
- 输出：out，如果不 flush，会在 response.writer 之后追加
- 配置：config
- 异常：exception

## 包含

```html
<!-- 静态包含，直接 out.print() -->
<%@ include file="" %>
<!-- 动态包含，转发到翻译的 jsp -->
<jsp:include page="">
```

# EL 表达式

```bash
# 是否为空
${ empty val }
```

## 11 个隐含对象

- pageContext
- pageSconpe、requestScope、sessionScope、applicationScope
- param、paramValues
- header、headerValues
- cookie
- initParam

## Base 标签

```jsp
<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
```

# JSTL

## 核心

```html
<!-- 设置数据 -->
<c:set var="" value="" scope=""/>

<!-- 输出 -->
<c:out value="" default="" escapeXml="" />

<!-- 条件 -->
<c:if test=""></c:if>

<!-- 分支 -->
<c:choose>
	<c:when test="">
  </c:when>
  <c:otherwise>
  </c:otherwise>
</c:choose>

<!-- url 拼接 -->
<c:url context="" value="">
	<c:param name="" value=""/>
</c:url>

<!-- 遍历 -->
<c:foreach items="" begin="" end="" var="" step="" varStatus="">
</c:foreach>
```

## 函数

## 格式化

## SQL

## XML