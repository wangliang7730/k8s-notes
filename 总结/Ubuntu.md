# Ubuntu

下载 rufus

## sudo 免密

```bash
sudo visudo

# Allow members of group sudo to execute any command
%sudo   ALL=(ALL:ALL) ALL
### 放在这里
sharon ALL=(ALL:ALL) NOPASSWD:ALL
```

## 镜像

参考：https://developer.aliyun.com/mirror/ubuntu?spm=a2c6h.13651102.0.0.3e221b11T1iUC9

```bash
cp /etc/apt/sources.list{,.back}
sudo vim /etc/apt/sources.list
```

### 18

```ini
deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
```

### 20

```ini
deb http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse
 
deb http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse
 
deb http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse
 
deb http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse
 
deb http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
```

```shell
sudo apt update
```

## WSL2 远程

`/etc/ssh/sshd_config`

```ini
Port=22
ListenAdress 0.0.0.0
PasswordAuthentication yes
```

```shell
# 用于安装RSA_KEY
dpkg-reconfigure openssh-server
sudo service ssh restart
```

## 安装

```bash
sudo dpkg -i
sudo apt -f install
sudo apt update --fix-missing

sudo apt autoremove
```

## 网络配置

*`/etc/network/interfaces`*

```ini
auto ens38
iface ens38 inet static
address 192.168.100.5
netmask 255.255.255.0
gateway 192.168.100.1
dns-nameservers 192.168.100.1
```

```bash
sudo service networking restart
# 或者
sudo /etc/init.d/networking restart
# 或者
sudo ifconfig ens38 down 
sudo ifconfig ens38 up
```

## 远程

参考：http://c-nergy.be/blog/?p=13390

```bash
sudo apt update
sudo apt install xserver-xorg-core
sudo apt install xrdp
sudo apt install xserver-xorg-core
sudo apt install xserver-xorg-input-all
sudo apt install xorgxrdp

reboot
```

## 安装驱动

参考：https://www.linuxidc.com/Linux/2019-02/157170.htm

```bash
ubuntu-drivers devices
```



## 快捷方式

*`/usr/share/applications/typora.desktop`*

```ini
[Desktop Entry]
Encoding=UTF-8
Name=Typora
Exec=/opt/Typora-linux-x64/Typora
Icon=/opt/Typora-linux-x64/resources/app/asserts/icon/icon_256x256@2x.png
Type=Application
```

## 仿苹果

***壁纸***

```bash
sudo apt install gnome-tweak-tool
    # 窗口 -> 放置
    # 外观 -> 光标 -> DMZ-Black
sudo apt install gnome-shell-extensions
    # 重启
    # 扩展 -> User themes
sudo apt install gnome-shell-extension-dashtodock

# 主题
https://github.com/paullinuxthemer/Mc-OS-themes
git init
git config core.sparseCheckout true
echo /Mc-OS-CTLina-Gnome-Dark-1.3 >> .git/info/sparse-checkout
git remote add origin https://github.com/paullinuxthemer/Mc-OS-themes.git
git pull origin master --depth 1
git read-tree -mu HEAD
sudo cp -r foo /usr/share/themes
# 图标
https://github.com/keeferrourke/la-capitaine-icon-theme # 太大了
# dash-to-dock
https://github.com/micheleg/dash-to-dock/tree/gnome-3.30
```

## 字体

原字体

```ini
窗口标题=Ubuntu 11
界面=Ubuntu Regular 11
文档=Sans Regular 11
等宽=Ubuntu Mono Regular 13
```

下载：http://www.mycode.net.cn/wp-content/uploads/2015/07/YaHeiConsolas.tar.gz

```bash
# 在系统目录下创建自定义字体目录
sudo mkdir -p /usr/share/fonts/consolas
# 解压压缩包
sudo tar -zxvf YaHeiConsolas.tar.gz -C /usr/share/fonts/consolas
# 修改字体权限
sudo chmod 644 /usr/share/fonts/consolas/*.ttf
# 刷新并安装字体
sudo mkfontscale && sudo mkfontdir && sudo fc-cache -fv
```

## 安装有道词典

- https://github.com/yomun/youdaodict_5.5

```bash
wget https://github.com/yomun/youdaodict_5.5/raw/master/youdao-dict_1.1.1-0~ubuntu_amd64.deb

sudo apt install python3 python3-pip python3-xdg python3-xlib
sudo apt install python3-dbus python3-lxml python3-pil python3-requests
sudo apt install python3-pyqt5 python3-pyqt5.qtmultimedia python3-pyqt5.qtquick python3-pyqt5.qtwebkit
sudo apt install gir1.2-appindicator3-0.1 qml-module-qtgraphicaleffects qml-module-qtquick-controls
sudo apt install libqt5multimedia5-plugins ttf-wqy-microhei
sudo apt install tesseract-ocr tesseract-ocr-eng tesseract-ocr-chi-sim tesseract-ocr-chi-tra
sudo apt install ubuntu-restricted-extras

# 查看是否安装了PyQt5
sudo pip3 list | grep PyQt5
sudo pip3 show PyQt5
# 若安装，则卸载之
sudo pip3 uninstall pyqt5

sudo dpkg -i youdao-dict_1.1.1-0~ubuntu_amd64.deb
```

## Qv2ray

- 下载 Qv2ray：https://f.yunti.run/v2/Qv2ray.v2.1.2.linux-x64.qt5.13.2.AppImage
- 下载 v2ray-core：https://github.com/v2ray/v2ray-core/releases/download/v4.22.1/v2ray-linux-64.zip

```bash
mkdir -p ~/.config/qv2ray/vcore/
cd ~/.config/qv2ray/vcore/
```

## Albert

- https://software.opensuse.org/download.html?project=home:manuelschneid3r&package=albert

```bash
sudo add-apt-repository ppa:noobslab/macbuntu
sudo apt-get update
sudo apt-get install albert
```

