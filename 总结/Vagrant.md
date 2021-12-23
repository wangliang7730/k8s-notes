# Vagrant

## VMware

**文档：**https://www.vagrantup.com/docs/providers/vmware

**下载 VMware 工具：**https://www.vagrantup.com/vmware/downloads

**安装插件：**`vagrant plugin install vagrant-vmware-desktop`

## 使用

``` bash
vagrant box list # 查看box列表
vagrant box add centos/7 # 添加
vagrant box add <路径> --name=centos/7 --provider=vmware_desktop # 下载后添加

vagrant up # 安装
vagrant ssh # 登录
```

