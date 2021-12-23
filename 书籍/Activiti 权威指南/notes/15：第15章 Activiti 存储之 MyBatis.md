---
title: 第15章 Activiti 存储之 MyBatis
hidden: true
---

# 第15章 Activiti 存储之 MyBatis

- [ ] 15.1 初始化 dataSource
- [ ] 15.2 Activiti 数据访问层关系分析
  - 15.2.1 实体类与数据库表的映射
  - 15.2.2 实例化 SqlSessionFactory
- [ ] 15.3 自定义Mapper实战
  - 15.3.1 自定义 Mapper
  - 15.3.2 自定义 SQL 执行原理
- [ ] 15.4 SessionFactory
  - 15.4.1 初始化 SessionFactory
  - 15.4.2 SessionFactory 架构
- [ ] 15.5 Session
  - 15.5.1 Session 架构
  - 15.5.2 实例化方式创建 Session实例
  - 15.5.3 反射方式创建 Session实例
  - 15.5.4 实例化 DbSqlSession
- [ ] 15.6 SQL 语句
  - 15.6.1 SQL 语句适配器
  - 15.6.2 SQL 执行 id 值生成规则
- [ ] 15.7 数据层和数据的关系
  - 15.7.1 PersistentObject 业务对象
  - 15.7.2 实体管理类
- [ ] 15.8 添加会话缓存
- [ ] 15.9 更新操作
  - 15.9.1 会话缓存方式更新
  - 15.9.2 SqlSession 方式更新
- [ ] 15.10 删除操作
  - 15.10.1 DeleteOperation 接口
  - 15.10.2 BulkDeleteOperation 删除数据
  - 15.10.3 CheckedDeleteOperation 删除数据
  - 15.10.4 乐观锁
- [ ] 15.11 刷新会话缓存入口
- [ ] 15.12 会话缓存数据持久化
  - 15.12.1 移除不必要的数据
  - 15.12.2 刷新序列化变量
  - 15.12.3 获取更新对象
  - 15.12.4 刷新数据
  - 15.12.5 解决依赖数据插人先后顺序
  - 15.12.6 性能优化
