---
date: 2021-12-08
updated: 2021-12-08
---

# 9 Deployment: 声明式地升级应用

## 9.1 更新运行在 pod 内的应用程序

### 9.1.1 删除旧版本 pod，使用新版本 pod 替换

### 9.1.2 先创建新 pod 再删除旧版本 pod

## 9.2 使用 ReplicationController 实现自动的滚动升级

### 9.2.1 运行第一个版本的应用

### 9.2.2 使用 kubectl 来执行滚动式升级

### 9.2.3 为什么 kubectl rolling-update已经过时

## 9.3 使用 Deployment 声明式地升级应用

### 9.3.1 创建一个 Deployment

### 9.3.2 升级 Deployment

### 9.3.3 回滚 Deployment

### 9.3.4 控制滚动升级速率

### 9.3.5 暂停滚动升级

### 9.3.6 阻止出错版本的滚动升级

## 9.4 本章小结
