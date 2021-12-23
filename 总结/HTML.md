# HTML

## 头

## 文本

## 图片

## 超链接

## 表格

## 表单

## HTML5

### aria-* 和 role

- aria：Accessible Rich Internet Application

比如下面的例子，不加 `aria-label` windows 讲述人会读“哈哈”，加了会读“呵呵”，`role` 设置为 button，会说按钮，chrome 还可能会崩溃。。。

```html
<label aria-label="呵呵">
  哈哈<input type="text" role="button">
</label>
```

## 实体

- 左右引用：\&laquo;、\&raquo;

- 箭头：\&larr;、\&rarr;