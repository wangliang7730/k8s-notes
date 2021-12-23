# Docsify

## nginx 配置

```nginx
server {
    listen                  80;
    listen                  [::]:80;
    server_name             book.sharonlee.top;
    root                    /usr/share/nginx/html/sharon-docsify;

    index                   index.html;

    location ~.*\.html$ {
        add_header Cache-Control "private, no-store, no-cache, must-revalidate, proxy-revalidate";
    }

    location ~ .*/_navbar.md$ {
        try_files $uri = 404;
    }

    location / {
        try_files $uri /index.html;
    }
}

server {
    listen                  443 ssl http2;
    listen                  [::]:443 ssl http2;
    server_name             book.sharonlee.top;
    root                    /usr/share/nginx/html/sharon-docsify;

    ssl_certificate         /etc/letsencrypt/*.sharonlee.top.cer;
    ssl_certificate_key     /etc/letsencrypt/*.sharonlee.top.key;

    index                   index.html;

    location ~.*\.html$ {
        add_header Cache-Control "private, no-store, no-cache, must-revalidate, proxy-revalidate";
    }

    location / {
        try_files $uri $uri/ $uri.html;
    }
}

```

