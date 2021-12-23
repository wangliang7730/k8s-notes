# VMWare

## 安装 VMWare Tool[^1]

```shell
mkdir /mnt/cdrom
mount /dev/cdrom /mnt/cdrom
tar zxvf /mnt/cdrom/VMwareTools-x.x.x-xxxx.tar.gz -C /tmp/
cd /tmp/vmware-tools-distrib/
./vmware-install.pl -d
```

## 共享文件夹

```shell
# 查看
vmware-hgfsclient
mkdir /mnt/hgfs
# 一次性挂载
vmhgfs-fuse .host:/vmware-share /mnt/hgfs
# 永久挂载
vim /etc/fstab
.host:/vmware-share    /mnt/hgfs        fuse.vmhgfs-fuse    defaults,allow_other    0    0
mount -a
```

## 问题

**安装程序无法自动安装Virtual Machine Communication Interface(VMCI)驱动程序，必须手动安装此驱动程序**：

下载：https://www.catalog.update.microsoft.com/search.aspx?q=kb4474419

## 参考

[^1]: [在 Ubuntu 虚拟机中安装 VMware Tools (1022525)](https://kb.vmware.com/s/article/1022525?lang=zh_CN)

