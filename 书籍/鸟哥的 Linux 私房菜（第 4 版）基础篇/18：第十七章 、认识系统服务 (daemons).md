---
date: 2021-11-03
updated: 2021-11-03
---

# 第十七章 、认识系统服务 (daemons)

## 17.1 什么是 daemon 与服务 (service)

### 17.1.1 早期 System V 的 init 管理行为中 daemon 的主要分类 (Optional)

### 17.1.2 systemd 使用的 unit 分类

## 17.2 透过 systemctl 管理服务

### 17.2.1 透过 systemctl 管理单一服务 (service unit) 的启动/开机启动与观察状态

### 17.2.2 透过 systemctl 观察系统上所有的服务

### 17.2.3 透过 systemctl 管理不同的操作环境 (target unit)

### 17.2.4 透过 systemctl 分析各服务之间的相依性

### 17.2.5 与 systemd 的 daemon 运作过程相关的目录简介

### 17.2.6 关闭网络服务

## 17.3 systemctl 针对 service 类型的配置文件

### 17.3.1 systemctl 配置文件相关目录简介

### 17.3.2 systemctl 配置文件的设定项目简介

### 17.3.3 两个 vsftpd 运作的实例

### 17.3.4 多重的重复设定方式：以 getty 为例

### 17.3.5 自己的服务自己作

## 17.4 systemctl 针对 timer 的配置文件

## 17.5 CentOS 7.x 预设启动的服务简易说明

## 17.6 重点回顾

## 17.7 本章习题

## 17.8 参考数据与延伸阅读
