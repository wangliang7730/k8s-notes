# Spring MVC

- aop 需要 aspectjweaver 包
- json 需要 jackson-databind

## 基本配置

*`spring-mvc.xml`*

```xml
<mvc:annotation-driven></mvc:annotation-driven>
<context:component-scan base-package="sharon.lee.atguigu.crowd.controller"></context:component-scan>
<mvc:default-servlet-handler />
<bean id="viewResolver" class="org.springframework.web.servlet.view.InternalResourceViewResolver">
  <property name="prefix" value="/WEB-INF/" />
  <property name="suffix" value=".jsp" />
</bean>

<!-- 简单的跳转，path 必须完全匹配 -->
<mvc:view-controller path="/admin-login.html" view-name="admin-login"/>
```

*`web.xml`*

```xml
<context-param>
  <param-name>contextConfigLocation</param-name>
  <param-value>classpath*:spring-*.xml</param-value>
</context-param>
<listener>
  <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
</listener>

<servlet>
  <servlet-name>dispatcherServlet</servlet-name>
  <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
  <init-param>
    <param-name>contextConfigLocation</param-name>
    <param-value>classpath:mvc-spring.xml</param-value>
  </init-param>
  <load-on-startup>1</load-on-startup>
</servlet>

<servlet-mapping>
  <servlet-name>dispatcherServlet</servlet-name>
  <url-pattern>/</url-pattern>
</servlet-mapping>

<filter>
  <filter-name>charsetfilter</filter-name>
  <filter-class>org.springframework.web.filter.CharacterEncodingFilter</filter-class>
  <init-param>
    <param-name>encoding</param-name>
    <param-value>UTF-8</param-value>
  </init-param>
  <init-param>
    <param-name>forceEncoding</param-name>
    <param-value>true</param-value>
  </init-param>
</filter>
```

## 拦截器

```xml
<mvc:interceptors>
  <mvc:interceptor>
    <mvc:mapping path="/**" />
    <mvc:exclude-mapping path="/admin/login" />
    <mvc:exclude-mapping path="/admin/logout" />
    <mvc:exclude-mapping path="/**/*.css" />
    <mvc:exclude-mapping path="/**/*.js" />
    <mvc:exclude-mapping path="/**/*.png" />
    <mvc:exclude-mapping path="/**/*.gif" />
    <mvc:exclude-mapping path="/**/*.jpg" />
    <mvc:exclude-mapping path="/**/*.jpeg" />
    <mvc:exclude-mapping path="/**/fonts/*" />
    <bean class="sharon.lee.atguigu.crowd.interceptor.LoginInterceptor" />
  </mvc:interceptor>
</mvc:interceptors>
```

## 静态资源

```xml
<!-- 必须在Spring的Dispatcher的前面 -->
<servlet-mapping>
  <servlet-name>default</servlet-name>
  <url-pattern>*.js</url-pattern>
  <url-pattern>*.css</url-pattern>
  <url-pattern>/images/*</url-pattern>
  <url-pattern>/fonts/*</url-pattern>
</servlet-mapping>

<mvc:default-servlet-handler />
```

```xml
<mvc:resources mapping="/css/**" location="/css/"/>
```

## 重定向

- redirect 要加 /，相对于 contextPath 根目录，否则会相对于当前访问路径，可能出现预料之外的情况
- 原生 sendRedirect 相对于主机根目录

## 跨域

- @CrossOrigin