# Activiti

## 工具

### IDE - [actBPM](https://plugins.jetbrains.com/plugin/7429-actibpm)

乱码问题：项目配置都设置成 UTF-8，IDEA 菜单 `Help->Edit Custom VM Options` 设置 `-Dfile.encoding=UTF-8`

## 整合 Spring

### 依赖

```xml
<dependency>
  <groupId>org.activiti</groupId>
  <artifactId>activiti-spring</artifactId>
</dependency>
```

### `activiti.cfg.xml` 配置

```xml
<bean id="dataSource" class="org.springframework.jdbc.datasource.DriverManagerDataSource">
  <property name="url" value="jdbc:mysql://192.168.100.100/demo-activiti"/>
  <property name="driverClassName" value="com.mysql.jdbc.Driver"/>
  <property name="username" value="root"/>
  <property name="password" value="root"/>
</bean>

<bean id="processEngineConfiguration" class="org.activiti.engine.impl.cfg.StandaloneProcessEngineConfiguration">
  <property name="dataSource" ref="dataSource"/>
  <property name="databaseSchemaUpdate" value="true"/>
</bean>
```

### `axtiviti-context.xml` 配置

```xml
<bean id="dataSource" class="org.springframework.jdbc.datasource.DriverManagerDataSource">
  <property name="url" value="jdbc:mysql://localhost:3306/demo-activiti"/>
  <property name="driverClassName" value="com.mysql.jdbc.Driver"/>
  <property name="username" value="root"/>
  <property name="password" value="root"/>
</bean>

<bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
  <property name="dataSource" ref="dataSource"/>
</bean>

<bean id="processEngineConfiguration" class="org.activiti.spring.SpringProcessEngineConfiguration">
  <property name="dataSource" ref="dataSource"/>
  <property name="databaseSchemaUpdate" value="create"/>
  <property name="transactionManager" ref="transactionManager"/>
  <property name="labelFontName" value="宋体"/>
  <property name="activityFontName" value="宋体"/>
</bean>

<bean id="processEngine" class="org.activiti.spring.ProcessEngineFactoryBean">
  <property name="processEngineConfiguration" ref="processEngineConfiguration"/>
</bean>

<bean id="repositoryService" factory-bean="processEngine" factory-method="getRepositoryService"/>
<bean id="runtimeService" factory-bean="processEngine" factory-method="getRuntimeService"/>
<bean id="taskService" factory-bean="processEngine" factory-method="getTaskService"/>
<bean id="historyService" factory-bean="processEngine" factory-method="getHistoryService"/>
<bean id="managementService" factory-bean="processEngine" factory-method="getManagementService"/>
```

### 创建流程实例

```java
ProcessEngineConfiguration processEngineConfiguration
  = ProcessEngineConfiguration.createProcessEngineConfigurationFromResource("activiti-spring.xml");
// 版本5 会生成23张表
ProcessEngine processEngine = processEngineConfiguration.buildProcessEngine();
```

## 流程定义

### 部署

```java
RepositoryService repositoryService = processEngine.getRepositoryService();
Deployment deployment = repositoryService.createDeployment().addClasspathResource("leave.bpmn").deploy();
```

一次部署可以添加多个流程及资源文件，一次部署对应表 `act_re_deployment`，一个流程对应表 `act_re_procdef`，一个资源对应表 `act_ge_bytearray`

### 查询

```java
Deployment leave = processEngine.getRepositoryService().createDeploymentQuery().processDefinitionKey("leave").singleResult();
```

## 流程实例

### 启动

```java
RuntimeService runtimeService = processEngine.getRuntimeService();
runtimeService.startProcessInstanceByKey("leave");
```

### 查询

### 代办

## Activiti 与 BPMN 2.0

## Activiti Explorer

下载：http://activiti.org/download.html

解压配置数据库和添加mysql驱动，访问：http://localhost:8080/activiti-explorer

用户：kermit/kermit

```text
activiti modeler 汉化的方式很简单，只是内容繁杂：将stencilset.json与editor-app——i18n——en.json这两个文件汉化后替换掉就可以了。

1.将zh-CN.json，放在en.json同目录。

2.在editor-app——app.js中找到

$translateProvider.preferredLanguage('en');
改为
    $translateProvider.preferredLanguage('zh-CN');
```

## springboot 集成 activiti modeler

参考：https://blog.csdn.net/zhangdaiscott/article/details/88240181

- https://github.com/Activiti/Activiti/releases/tag/activiti-5.22.0

账号：kermit/kermit

## 监听器

### 流程执行监听器

```java
public interface ExecutionListener extends Serializable {

  String EVENTNAME_START = "start";
  String EVENTNAME_END = "end";
  String EVENTNAME_TAKE = "take";

  void notify(DelegateExecution execution) throws Exception;
}
```

### 任务监听器

```java
public interface TaskListener extends Serializable {

  String EVENTNAME_CREATE = "create";
  String EVENTNAME_ASSIGNMENT = "assignment";
  String EVENTNAME_COMPLETE = "complete";
  String EVENTNAME_DELETE = "delete";
  String EVENTNAME_ALL_EVENTS = "all";

  void notify(DelegateTask delegateTask);
}
```

### 设置监听器

设置监听器可以指定监听器的类型、事件和字段

#### 类型

- class：直接指定类名
- delegateExpression：EL 表达式动态设置类名

#### 字段

```java
public class CreateTaskListener implements TaskListener {

  private static final long serialVersionUID = 1L;
  private Expression content;

  @Override
  public void notify(DelegateTask delegateTask) {
    System.out.println(content.getValue(delegateTask));
  }
}
```

## 参考

- https://gitee.com/yanhonglei/activiti-in-action-codes

