# Spring Security

## 快速开始

**引入依赖：**

```xml
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-security</artifactId>
</dependency>
```

**默认配置：**

```java
@EnableWebSecurity
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        super.configure(http);
    }
}
```

访问会跳转到默认的登录页面，因为父类默认配置的是

```java
    protected void configure(HttpSecurity http) throws Exception {
        http.authorizeRequests((requests) -> requests.anyRequest().authenticated());
        http.formLogin();
        http.httpBasic();
    }
```

默认用户名为 user，密码会打印在控制台

## 登录配置

修改默认的用户名密码：

```properties
spring.security.user.name
spring.security.user.password
```

相关配置类：

```java
class UserDetailsServiceAutoConfiguration;
class SecurityProperties;
class FormLoginConfigurer;
```

登录配置：

```java
.and()
.formLogin()
.loginPage("/login.html")
.loginProcessingUrl("/doLogin")
.usernameParameter("name")
.passwordParameter("passwd")
.defaultSuccessUrl("/index")
.successForwardUrl("/index")
.failureForwardUrl()
.failureUrl()
.permitAll()
.and()
```

注销配置：

```java
.and()
.logout()
.logoutUrl("/logout")
.logoutRequestMatcher(new AntPathRequestMatcher("/logout","POST"))
.logoutSuccessUrl("/index")
.deleteCookies()
.clearAuthentication(true)
.invalidateHttpSession(true)
.permitAll()
.and()
```

## UserDetailsManager

```java
class JdbcUserDetailsManager;
// sql org/springframework/security/core/userdetails/jdbc/users.ddl
```



## 认证配置

```java
protected void configure(HttpSecurity http) throws Exception {
  http.antMatchers()
    .permitAll()
    .anyRequest()
    .authenticated()
    .anyRequest()
    .hasRole()
    .hasAuthority()
  .and().formLogin()
    .loginPage()
    .loginProcessUrl()
    .successHandler()
    .failureHandler()
  .and().httpBasic()
  .and().csrf().disable()
}
```

## 用户接口

UserDetailsService：

- InMemoryUserDetailsManager
- JdbcUserDetailsManager，建表语句在 `/org/springframework/security/core/userdetails/jdbc/users.ddl`

## 过滤器

## AuthenticationProvider

## AuthenticationDetailsSource