# OpenOffice

```bash
soffice -headless -accept=“socket,host=127.0.0.1,port=8100;urp;” -nofirststartwizard
soffice --headless --accept="socket,host=127.0.0.1,port=2002;urp;"

no suitable windowing system found, exiting

yum groupinstall "X Window System"

/opt/openoffice4/program/soffice -headless -accept="socket,host=127.0.0.1,port=2002;urp;"

./soffice.bin: error while loading shared libraries: libXext.so.6: cannot open shared object file: No such file or directory
yum install libXext
```

## 中文乱码

```bash
yum install mkfontscale
mkfontscale
# rm -rf *.fon
mkfontdir
fc-cache
```

# LibreOffice

```bash
yum install -y cairo cups-libs libSM

yum install cairo
yum install cups-libs
yum install libSM

soffice --headless --invisible --convert-to pdf /opt/sztc-hn/upload/xxx.docx --outdir /opt/sztc-hn/upload/
```

## Docker 安装 online

- [DOCKER 部署在线文件转换服务--LIBRE OFFICE ONLINE](https://www.freesion.com/article/7913575651/)

```shell
docker pull libreoffice/online
docker run --name libreoffice-online -d libreoffice/online
docker cp libreoffice-online:/etc/loolwsd /etc
# 修改 loolwsd.xml 中 SSL 为 false
docker run --name libreoffice-online -e "username=admin" -e "password=123456" -p 9980:9980 -v /etc/loolwsd/:/etc/loolwsd --cap-add MKNOD -d libreoffice/online

http://10.10.120.140:9980/loleaflet/dist/admin/admin.html
http://10.10.120.140:9980/hosting/discovery
```

