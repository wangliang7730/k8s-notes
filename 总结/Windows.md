# Windows

## WSL

### 安装

管理员身份运行：

```shell
# 启用“适用于 Linux 的 Windows 子系统”可选功能
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
# 启用“虚拟机平台”可选功能
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
# 重启
# WSL 2 需要安装
https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi
# 去商店安装linux
```

### 手动安装

- https://docs.microsoft.com/en-us/windows/wsl/install-manual#installing-your-distro

### WSL 1 转换为 WSL 2

```shell
wsl --list --verbose
wsl --set-version <distribution name> 2
wsl --set-default-version 2
```

### 默认使用 Root 用户

```shell
# 设置 root 用户密码
sudo passwd root
# PowerShell
ubuntu1804 config --default-user root
sc stop LxssManager
sc start LxssManager
sc query LxssManager
# 删除用户
userdel -r <用户名>
```

> **参考：**
>
> - [How to change default user in WSL Ubuntu bash on Windows 10](https://askubuntu.com/questions/816732/how-to-change-default-user-in-wsl-ubuntu-bash-on-windows-10)

### WSL 2 重启 IP 会变化

**方式一修改 host：**

- https://www.codenong.com/cs106712191/
- https://github.com/shayne/go-wsl2-host

> go-wsl2-host：
>
> - hosts 文件去掉只读权限
> - windows管理工具-本地安全策略-本地策略-用户分配权限 ,找到“作为服务登录”把当前电脑登录用户名加入进去,再次重新启动服务即可

**方式二添加IP：**

- https://github.com/microsoft/WSL/issues/4210

```powershell
netsh interface ip add address "vEthernet (WSL)" 192.168.50.1 255.255.255.0
wsl -d Ubuntu-18.04 -u root ip addr add 192.168.50.2/24 broadcast 192.168.50.255 dev eth0 label eth0:1
```

### WSL2 开启 systemctl

- https://github.com/DamionGans/ubuntu-wsl2-systemd-script

> - enable 不起作用
> - 不方便卸载

### 开启 SSH

```shell
ssh-keygen -A

# /etc/ssh/sshd_config
PermitRootLogin yes
PasswordAuthentication yes
```

### 删除

```shell
wsl --unregister DISTRO-NAME
```

### 启动目录

默认：`%USERPROFILE%`

修改：`\\wsl$\DistroName`，如 `\\wsl$\Ubuntu-18.04\root`

### 排错

- WslRegisterDistribution failed with error: 0x80370102

需要启用虚拟机平台

- WslRegisterDistribution failed with error: 0x800701bc

需要安装更新包：[步骤 4 - 下载 Linux 内核更新包](https://docs.microsoft.com/zh-cn/windows/wsl/install-win10#step-4---download-the-linux-kernel-update-package)

https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi

### systemd

https://github.com/DamionGans/ubuntu-wsl2-systemd-script

### 内存

https://zhuanlan.zhihu.com/p/345645621

https://github.com/microsoft/WSL/issues/4166

https://docs.microsoft.com/en-us/windows/wsl/release-notes#build-18945

https://docs.microsoft.com/en-us/windows/wsl/wsl-config#configure-global-options-with-wslconfig

### 去除保留端口

https://links.jianshu.com/go?to=https%3A%2F%2Fgithub.com%2Fdocker%2Ffor-win%2Fissues%2F3171%23issuecomment-459205576

## PowerShell 美化

```shell
# 安装 https://github.com/JanDeDobbeleer/oh-my-posh2
Install-Module posh-git -Scope CurrentUser
Install-Module oh-my-posh -Scope CurrentUser
# 打开配置文件
if (!(Test-Path -Path $PROFILE )) { New-Item -Type File -Path $PROFILE -Force }
notepad $PROFILE
# 设置
Import-Module posh-git
Import-Module oh-my-posh
Set-Theme PowerLine
# 如果报错：无法加载文件 xxx，因为在此系统上禁止运行脚本。用管理员运行
set-ExecutionPolicy RemoteSigned
# 如果报错：Set-Theme : 无法将“Set-Theme”项识别为。版本 3 有变化
Set-PoshPrompt -Theme PowerLine
# 字体乱码：https://github.com/be5invis/Sarasa-Gothic/releases
```

## Windows Terminal 美化

### 安装 zsh

```shell
# 查看系统当前 shell
echo $SHELL
# 查看系统安装的 shell
cat /etc/shells
# 安装 zsh
sudo apt install zsh
# 设置为默认 shell
sudo chsh -s $(which zsh)
```

### 安装 oh my zsh

```shell
curl -Lo install.sh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
sh install.sh
# 重进
# 设置主题：https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
vim ~/.zshrc
ZSH_THEME="agnoster"
source ~/.zshrc
# 查看有哪些主题
ls ~/.oh-my-zsh/themes
# 查看当前主题
echo $ZSH_THEME
# 配置 random 主题时查看当前出题
echo $RANDOM_THEME
# https://github.com/romkatv/powerlevel10k

## windows 字体字体
# https://github.com/powerline/fonts
# 使用 Fira Mono for Powerline

## 插件
# https://github.com/zsh-users/zsh-syntax-highlighting
# https://github.com/zsh-users/zsh-autosuggestions
```

> **稀疏检出：**
>
> ```shell
> mkdir powerline-fonts
> cd powerline-fonts
> git init
> git config core.sparseCheckout true
> echo /FiraMono >> .git/info/sparse-checkout
> git remote add origin https://hub.fastgit.org/powerline/fonts.git
> git pull origin master --depth 1
> git read-tree -mu HEAD
> ```

### 配色

- https://github.com/mbadolato/iTerm2-Color-Schemes/tree/master/windowsterminal

## 启停

```shell
title xxx
taskkill /fi "WINDOWTITLE eq xxx"
```

## 参考

- [适用于 Linux 的 Windows 子系统安装指南 (Windows 10)](https://docs.microsoft.com/zh-cn/windows/wsl/install-win10)

- https://www.jianshu.com/p/aac4c5e87a3a

- [玩转WSL(3)之安装并配置oh-my-zsh](https://zhuanlan.zhihu.com/p/199798102)