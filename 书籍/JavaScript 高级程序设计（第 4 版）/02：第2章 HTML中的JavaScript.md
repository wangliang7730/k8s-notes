---
date: 2021-10-19
updated: 2021-10-19
---

# 第2章 HTML中的JavaScript

## 2.1 \<script\>元素

**【\<script\> 元素的属性】**

-   `async`：表示应该立即开始下载脚本，但不能阻止其他页面动作
-   `charset`：代码字符集
-   `crossorigin`：`crossorigin="anonymous"` 配置文件请求不必设置凭据标志。`crossorigin="use-credentials"` 设置凭据标志，意味着出站请求会包含凭据
-   `defer`：表示脚本可以延迟到文档完全被解析和显示之后再执行
-   `integrity`：允许比对接收到的资源和指定的加密签名以验证子资源完整性（SRI，Subresource Integrity）。如果接收到的资源的签名与这个属性指定的签名不匹配，则页面会报错，脚本不会执行
-   `language`：废弃。最初用于表示代码块中的脚本语言（如"JavaScript"、"JavaScript 1.2"或"VBScript"）。大多数浏览器都会忽略这个属性，不应该再使用它
-   `src`：表示包含要执行的代码的外部文件
-   `type`：代替 `language`，表示代码块中脚本语言的内容类型（也称 MIME 类型）。按照惯例，这个值始终都是"text/javascript"，尽管“text/javascript”和“text/ecmascript”都已经废弃了。JavaScript 文件的 MIME 类型通常是"application/x-javascript"

---

-   外部 script 和行内代码同时存在时，会忽略行内代码

### 2.1.1 标签位置

过去，`<script>` 元素都被放在页面的 `<head>` 标签内，会阻塞页面渲染。现在放在 `<body>` 元素中页面内容的后面：

```html
<body>
    <!-- 这里是页面内容 -->
    ...
    <script src="example1.js"></script>
</body>
```

### 2.1.2 推迟执行脚本

`defer`：

-   立即下载，但按照出现的顺序延迟执行
-   会在 DOMContentLoaded 事件之前执行
-   不过在实际当中，推迟执行的脚本不一定总会按顺序执行或者在 DOMContentLoaded 事件之前执行，因此最好只包含一个这样的脚本
-   会忽略行内脚本的 defer 属性

>   🔔 **注意：**对于 XHTML 文档，指定 defer 属性时应该写成 `defer="defer"`

### 2.1.3 异步执行脚本

`async`：

-   不保证能按照它们出现的次序执行
-   保证会在页面的 load 事件前执行，但可能会在 DOMContentLoaded 之前或之后

>   🔔 **注意：**对于 XHTML 文档，指定 async 属性时应该写成 `async="async"`

### 2.1.4 动态加载脚本

```js
let script = document.createElement('script');
script.src = 'gibberish.js';
document.head.appendChild(script);
```

-   默认情况下相当于添加了 async 属性

-   可以明确设置为同步加载 `script.async = false`

-   想让预加载器知道这些动态请求文件的存在，可以在文档头部显式声明它们

    ```html
    <link rel="preload" href="gibberish.js">
    ```

### 2.1.5 XHTML中的变化

-   必须指定 type 属性且值为 text/javascript，HTML 中则可以没有这个属性

### 2.1.6 废弃的语法

对不支持 JavaScript 的浏览器隐藏嵌入的 JavaScript 代码：

```html
<!-- 已经不再必要，而且不应该再使用了 -->
<script><!--
    ...
//--></script>
```

## 2.2 行内代码与外部文件

-   可维护性
-   缓存
-   适应未来

## 2.3 文档模式

-   混杂模式（quirks mode）：约定省略文档开头的 doctype 声明作为开关

-   准标准模式（almost standards mode）：

    ```html
    <!-- HTML 4.01 Transitional -->
    <!DOCTYPE HTML PUBLIC
    "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">
    
    <!-- HTML 4.01 Frameset -->
    <!DOCTYPE HTML PUBLIC
    "-//W3C//DTD HTML 4.01 Frameset//EN"
    "http://www.w3.org/TR/html4/frameset.dtd">
    
    <!-- XHTML 1.0 Transitional -->
    <!DOCTYPE html PUBLIC
    "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
    
    <!-- XHTML 1.0 Frameset -->
    <!DOCTYPE html PUBLIC
    "-//W3C//DTD XHTML 1.0 Frameset//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">
    ```

-   标准模式（standards mode）：

    ```html
    <!-- HTML 4.01 Strict -->
    <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"
    "http://www.w3.org/TR/html4/strict.dtd">
    
    <!-- HTML5 -->
    <!DOCTYPE html>
    
    <!-- XHTML 1.0 Strict -->
    <!DOCTYPE html PUBLIC
    "-//W3C//DTD XHTML 1.0 Strict//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
    ```

## 2.4 \<noscript\>元素

-   `<noscript>` 元素可以包含任何可以出现在 `<body>` 中的 HTML 元素，`<script>` 除外。

-   下列两种情况下，浏览器将显示包含在 `<noscript>` 中的内容：

    -   浏览器不支持脚本

    -   浏览器对脚本的支持被关闭

## 2.5 小结

-   要包含外部 JavaScript 文件，必须将 src 属性设置为要包含文件的 URL。文件可以跟网页在同一台服务器上，也可以位于完全不同的域。
-   所有 `<script>` 元素会依照它们在网页中出现的次序被解释。在不使用 defer 和 async 属性的情况下，包含在 `<script>` 元素中的代码必须严格按次序解释。
-   对不推迟执行的脚本，浏览器必须解释完位于 `<script>` 元素中的代码，然后才能继续渲染页面的剩余部分。为此，通常应该把 `<script>` 元素放到页面末尾，介于主内容之后及 `</body>` 标签之前。
-   可以使用 defer 属性把脚本推迟到文档渲染完毕后再执行。推迟的脚本原则上按照它们被列出的次序执行。
-   可以使用 async 属性表示脚本不需要等待其他脚本，同时也不阻塞文档渲染，即异步加载。异步脚本不能保证按照它们在页面中出现的次序执行。
-   通过使用 `<noscript>` 元素，可以指定在浏览器不支持脚本时显示的内容。如果浏览器支持并启用脚本，则 `<noscript>` 元素中的任何内容都不会被渲染。

