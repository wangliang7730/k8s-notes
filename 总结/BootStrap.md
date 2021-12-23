# BootStrap

## 全局 CSS

### 栅格系统

屏幕大小：

- 768)：xs
- [768, 992)：sm
- [992, 1200)：md
- [1200：lg

类：

- container
- container-fluid
- row
- col-xx-n
- col-xx-offset-n：用的margin实现，占位置
- col-xx-push/pull-n：用的相对对位，不占位置

### 排版样式

- lead：增大字体
- text-left/center/right
- text-lowercase/uppercase/capitalize
- 缩略语：\<abbr title=""\>，initialism：90%字体大小，大写
- 地址：\<address\>
- 引用：\<blockquote\>，blockquote-reverse
- 列表：list-unstyled、list-inline
- 描述：dl-horizontal
- 代码：\<kbd\>、\<pre\>、pre-scrollable、\<var\>、\<samp\>
- 标签：label、label-default/-primary/...
- 徽章：badge
- 巨幕：jumbotron，和屏幕一样大：放在 container 外面
- 页头：page-title
- 缩略图：thumbnail，描述 caption
- 警告：alert/alert-success/info/warning/danger、alert-link，[可关闭警告框](#可关闭警告框)
- 列表组：list-group、list-group-item/-情景
- 凹陷：well-大小
- 字体图标：glyphicon、glyphicon-*

### 表格

- table
- 隔行：table-striped
- 边框：table-bordered
- 悬停：table-hover
- 紧凑：table-condensed
- 状态颜色：tr 或 td 设置，active、success、info、warning、danger
- 响应式，滚动条：table 父元素，table-responsive

### 按钮

- btn：input、a、button
- 样式：btn-default/primary/success/info/warning/danger/link
- 大小：btn-lg/sm/xs/block
- 激活：active
- 禁用：disabled、disabled="disabled"

### 表单

- form-group：标签和表单元素放这里面
- form-horizontal：栅格，form-group 相当于 row
- 表单元素：form-control
- 内联表单：form-inline
- 多/单选框：checkbox/-inline、radio/-inline
- sr-only：屏幕阅读器用，不显示
- 标签右对齐：control-label
- p 居中对齐：form-control-static
- 禁用所有：fieldset，a 不行
- 帮助文本：help-block
- 校验：has-warning/error/success
- 尺寸：input-xx、form-group-xx

### 图片

- 圆角：img-rounded
- 圆：img-circle
- 裱框：img-thumbnail
- 响应式图片：img-responsive，居中用 center-block

### 辅助类

- 文本颜色：text-muted/primary/success/info/warning/danger
- 背景颜色：bg-primary/success/info/warning/danger
- 浮动：pull-left/right
- 居中：center-block
- 清除浮动：clearfix
- 显示/隐藏：show/hidden/invisible
- sr-only/-focus
- 隐藏文本：text-hide
- 三角：caret
- 转义字符&times;：\&times;

### 响应式工具

- 显示：visible-xx-block/inline/inline-block
- 隐藏：hiddent-xx
- 打印隐藏：xx 换成 print

## 组件

### 下拉菜单

- 基本下拉菜单：父类为 dropdown 或 btn-group

```html
<div class="dropdown open">
  <button class="dropdown-toggle" data-toggle="dropdown"></button>
  <ul class="dropdown-menu">
    <li><a href="#">Action</a></li>
    <li><a href="#">Action</a></li>
  </ul>
</div>
```

- 右对齐：ul.dropdown-menu-right
- 标题：li.dropdown-header
- 禁用：li.disabled
- 分隔符：li.divider

- 控制按钮：dropdown-toggle、data-toggle
- 分裂的下拉菜单：按钮组第二个 caret 设置 toggle
- 上弹：dropup

### 按钮组

- btn-group：>btn
- btn-toolbar：>btn-group
- 大小：btn-group-xs/sm/lg
- 下拉菜单放入按钮组：dropdown 换成 btn-group 嵌入父 btn-group
- 垂直：btn-group-vertical

### 标签页

- 导航标签：nav、nav-tabs、active
- 胶囊式（看起来像按钮）：nav-pills，垂直加上 nav-stacked
- 响应式，大屏幕水平小屏幕垂直：nav-justified
- 可以嵌入下拉菜单

### 导航栏

#### 基本结构

```html
<nav class="navbar navbar-default">
  <div class="navbar-header">
    <a href="#" class="navbar-brand">标题</a>
  </div>
	<div>
    <ul class="nav navbar-nav">
      <li><a href="#">链接1</a></li>
      <li><a href="#">链接2</a></li>
  	</ul>
    <form class="navbar-form"></form>
  </div>
</nav>
```

- 父元素为 nav 或 role 为 navigation
- 无序列表：navbar-nav nav

- 表单：navbar-form
- 按钮：navbar-btn
- 文本：navbar-text
- 链接：navbar-link
- 黑色：navbar-inverse

#### 折叠

- navbar-header 中添加按钮

```html
<button class="navbar-toggle collapsed" data-toggle="collapse" data-target="#nav-id">
  <span class="icon-bar"></span>
  <span class="icon-bar"></span>
  <span class="icon-bar"></span>
</button>
```

- navbar-nav 放在 navbar-collapse 中

```html
<div class="collapse navbar-collapse" id="nav-id"></div>
```

#### 位置

- 内部左右：navbar-left/right

- 固定定位：navbar-fixed-top/bottom

- 静态定位到顶部：navbar-static-top，不会到页面顶部，默认静态定位而已

### 面包屑导航

```html
<ol class="breadcrumb">
  <li><a href="#">Home</a></li>
  <li><a href="#">Library</a></li>
  <li class="active">Data</li>
</ol>
```

### 分页

- pagination
  - 大小：-/lg/sm
- 翻页：pager
  - 位置：previous/next

### 可关闭警告框

```html
<div class="alert alert-warning alert-dismissible">
  <button type="button" class="close" data-dismiss="alert"><span>&times;</span></button>
  <strong>警告！</strong> 啊啊啊啊啊啊啊
</div>
```

### 进度条

- 结构：progress
  - -progress-bar
  - style="width: x%"
- 颜色：progress-bar-success/...
- 条纹：progress-bar-striped，active 动画
- 堆叠：放多个

### 媒体对象【TODO】

### 面板

- panel、panel-default、panel-情景
  - panel-heading
    - panel-title
  - panel-body
  - panel-footer

## 插件

### 模态框 modal

> ***属性***

- backdrop：点击背景是否关闭
- keyboard：ESC 是否关闭
- show：默认是否显示

- remote：加载指定页面

> ***方法***

- toggle
- show
- hide
- handleUpdate：TODO

> ***事件***

- show.bs.modal
- shown.bs.modal
- hide.bs.modal
- hidden.bs.modal
- loaded.bs.modal

