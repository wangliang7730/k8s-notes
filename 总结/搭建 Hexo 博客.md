---
date: 2021-06-21
---

# 搭建 Hexo 博客


```shell
git clone https://github.com/hexojs/hexo-starter.git
```

## 发布路径

***_config.yml*：**

```yaml
# 资源路径与文章路径一致
permalink: _posts/:title.md.html
# 拷贝所有资源文件
include: "_posts/**/*"
# 为了精确，排除 md 文件，否则会存在 foo.html 和 foo.md.html 两个
exclude: "_posts/**/*.md"
```

## 隐藏文章

```shell
npm i hexo-hide-posts
```

为了默认隐藏，只有配置了 `show: true` 才显示，在此插件上自己添加 *scripts/show-filter.js*：

```js
// front-matter 配置了 show: true 才显示
hexo.extend.filter.register('before_generate', function() {
    this._bindLocals();

    const allPosts = this.locals.get('posts');
    const hiddenPosts = allPosts.filter(post => !post.show);
    const showPosts = allPosts.filter(post => post.show);

    this.locals.set('all_posts', allPosts);
    this.locals.set('hidden_posts', hiddenPosts);
    this.locals.set('posts', showPosts);
});
```

> 直接建一个 js 文件放到 *scripts* 文件夹，会自动加载

## Fluid 主题

- https://github.com/fluid-dev/hexo-theme-fluid
- https://hexo.fluid-dev.com/docs/guide/

## Nginx 配置

```nginx
server {
    listen                  80;
    listen                  [::]:80;
    server_name             blog.sharonlee.top;
    root                    /usr/share/nginx/html/sharonlee;

    index                   index.html;

    location ~.*\.html$ {
        add_header Cache-Control "private, no-store, no-cache, must-revalidate, proxy-revalidate";
    }

    location / {
        try_files $uri $uri/ $uri.html;
    }
}

server {
    listen                  443 ssl http2;
    listen                  [::]:443 ssl http2;
    server_name             blog.sharonlee.top;
    root                    /usr/share/nginx/html/sharonlee;

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

