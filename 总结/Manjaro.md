# Manjaro

## 无线网卡驱动

```shell
# https://github.com/brektrou/rtl8821CU
sudo pacman -Sw lib32-glibc make gcc linux59 linux59-header
```

## pacman

```shell
pacman -S # 安装
	-Sw # 下载 /var/cache/pacman/pkg
	-U # 本地安装
```

## 镜像

```shell
sudo pacman-mirrors -i -c China -m rank
sudo pacman -Syy
```

