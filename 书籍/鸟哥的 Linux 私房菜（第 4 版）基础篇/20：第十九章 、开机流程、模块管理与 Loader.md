---
date: 2021-11-03
updated: 2021-11-03
---

# 第十九章 、开机流程、模块管理与 Loader

## 19.1 Linux 的开机流程分析

### 19.1.1 开机流程一览

### 19.1.2 BIOS, boot loader 与 kernel 载入

### 19.1.3 第一支程序 systemd 及使用 default.target 进入开机程序分析

### 19.1.4 systemd 执行 sysinit.target 初始化系统、basic.target 准备系统

### 19.1.5 systemd 启动 multi-user.target 下的服务

### 19.1.6 systemd 启动 graphical.target 底下的服务

### 19.1.7 开机过程会用到的主要配置文件

## 19.2 核心与核心模块

### 19.2.1 核心模块与相依性

### 19.2.2 核心模块的观察

### 19.2.3 核心模块的加载与移除

### 19.2.4 核心模块的额外参数设定：/etc/modprobe.d/*conf

## 19.3 Boot Loader: Grub2

### 19.3.1 boot loader 的两个 stage

### 19.3.2 grub2 的配置文件 /boot/grub2/grub.cfg 初探

### 19.3.3 grub2 配置文件维护 /etc/default/grub 与 /etc/grub.d

### 19.3.4 initramfs 的重要性与建立新 initramfs 文件

### 19.3.5 测试与安装 grub2

### 19.3.6 开机前的额外功能修改

### 19.3.7 关于开机画面与终端机画面的图形显示方式

### 19.3.8 为个别选单加上密码

## 19.4 开机过程的问题解决

### 19.4.1 忘记 root 密码的解决之道

### 19.4.2 直接开机就以 root 执行 bash 的方法

### 19.4.3 因文件系统错误而无法开机

## 19.5 重点回顾

## 19.6 本章习题

## 19.7 参考数据与延伸阅读
