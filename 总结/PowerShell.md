# PowerShell

## 美化

### 安装字体

- https://github.com/powerline/fonts

```powershell
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
.\install.ps1
```

- https://github.com/be5invis/Sarasa-Gothic



### 安装 oh-my-posh

- https://github.com/JanDeDobbeleer/oh-my-posh2

- https://github.com/JanDeDobbeleer/oh-my-posh

```powershell
Install-Module posh-git -Scope CurrentUser
Install-Module oh-my-posh -Scope CurrentUser
# 打开配置文件
if (!(Test-Path -Path $PROFILE )) { New-Item -Type File -Path $PROFILE -Force }
notepad $PROFILE
# 配置
Import-Module posh-git
Import-Module oh-my-posh
Set-PoshPrompt -Theme PowerLine
# 样式在
$HOME\Documents\WindowsPowerShell\Modules\oh-my-posh\版本\themes
# 或者查看
https://github.com/JanDeDobbeleer/oh-my-posh/tree/main/themes
```

### 参考

- https://blog.csdn.net/weixin_44490152/article/details/113854767

## 安装 chocolatey

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
```

