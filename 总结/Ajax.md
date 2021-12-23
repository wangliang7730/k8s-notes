# Ajax

AJAX 是异步的 JavaScript 和 XML（**A**synchronous **J**avaScript **A**nd **X**ML）。简单点说，就是使用 `XMLHttpRequest` 对象与服务器通信。

## 创建实例

```js
// Old compatibility code, no longer needed.
if (window.XMLHttpRequest) { // Mozilla, Safari, IE7+ ...
    httpRequest = new XMLHttpRequest();
} else if (window.ActiveXObject) { // IE 6 and older
    httpRequest = new ActiveXObject("Microsoft.XMLHTTP");
}
```

## 发送 GET 请求

```js
httpRequest.open('GET', 'http://localhost:3000/posts/1', true)
httpRequest.responseType = 'json'
httpRequest.send();

httpRequest.onreadystatechange = function () {
  if (httpRequest.readyState === XMLHttpRequest.DONE && httpRequest.status === 200) {
    console.log(httpRequest.response)
  }
}
```

## 发送 POST 请求

```js
httpRequest.open('POST', 'http://localhost:3000/posts', true)
httpRequest.setRequestHeader('Content-Type', 'application/json')
httpRequest.responseType = 'json'
httpRequest.send(JSON.stringify({ title: 'foo', author: 'bar' }))

httpRequest.onreadystatechange = function () {
  if (httpRequest.readyState === XMLHttpRequest.DONE && httpRequest.status === 200) {
    console.log(httpRequest.response)
  }
}
```

## readyState

| 值   | 状态               | 描述                                                |
| ---- | ------------------ | --------------------------------------------------- |
| `0`  | `UNSENT`           | 代理被创建，但尚未调用 open() 方法。                |
| `1`  | `OPENED`           | `open()` 方法已经被调用。                           |
| `2`  | `HEADERS_RECEIVED` | `send()` 方法已经被调用，并且头部和状态已经可获得。 |
| `3`  | `LOADING`          | 下载中； `responseText` 属性已经包含部分数据。      |
| `4`  | `DONE`             | 下载操作已完成。                                    |

## 参考

- [XMLHttpRequest](https://developer.mozilla.org/zh-cn/docs/web/api/xmlhttprequest)
- [什么是AJAX？](https://developer.mozilla.org/zh-CN/docs/Web/Guide/AJAX/Getting_Started#什么是ajax？)

