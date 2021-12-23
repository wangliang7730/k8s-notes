# Eclipse

## 设置 JVM

*eclipse.ini*

```ini
-vm
C:\Program Files\Java\jdk-11.0.2\bin\javaw.exe
```

## 镜像设置

参考：https://lug.ustc.edu.cn/wiki/mirrors/help/eclipse/

> 以 Luna 为例，点击 `Help` → `Install New Software...` → `Available Software Sites` 可以看到所有的更新源，将其中的 `download.eclipse.org` 全部替换成 `mirrors.ustc.edu.cn/eclipse` 即可。

## Tomcat 服务器

- *`Window/Show View/Servers`*

## 常用设置

```ini
# 代码提示：Java > Editor > Content Assist
.abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ
disable insertion triggers except 'Enter'
# 显示空白字符：General > Editors > Text Editors > Show whitespace characters
# 两空格代替tab：Java > Code Style > Formatter > Edit > Profile name
```

## 插件

```ini
# Install > Update > Available Software Sites
http://mirrors.ustc.edu.cn/eclipse/
https://mirrors.tuna.tsinghua.edu.cn/eclipse/
```

- 主题：DevStyle 

### Activiti Designer

- https://github.com/Activiti/Activiti-Designer/releases

需要的 jar 包：http://mirror.neu.edu.cn/eclipse/modeling/emf/validation/updates/releases/R201405281429/plugins/

org.eclipse.emf.validation_1.7.0.201306111341.jar，
org.eclipse.emf.transaction_1.4.0.v20100331-1738.jar，
org.eclipse.emf.workspace_1.5.1.v20120328-0001.jar