# Vue.js

- methods 中访问 data 数据使用 this

## vue-devtools

- [ ] TODO


## 基本

```javascript
<div id="app">
  {{ message }}
</div>

var app = new Vue({
  el: '#app',
  data: {
    message: 'Hello Vue!'
  }
  methods: {
  
	}
})
```

## 指令

### `{{}}`、v-text、v-html、v-model

### v-cloak

```css
[v-cloak] {
  display: none;
}
```

### v-bind:

- 简写 `:`


> ***class***

- 对象：{className1: bool, 'className2': bool}，可以为定义的数据或 computed 属性

- 数组：['className1', 'className2']
  - 字符串可以用变量定义
  - 可以用三元表达式，活着直接使用对象语法

> ***style***

- 对象：驼峰命名或横线分割加引号
- 数组

### v-on:

- 简写 `@`

修饰符，可多个修饰：

- .stop：阻止冒泡
- .capture：捕获
- .prevent：阻止默认行为
- .self：为 target 时才触发
- .once：只触发一次

> ***按键修饰符***

- `.enter`
- `.tab`
- `.delete`
- `.esc`
- `.space`
- `.up`
- `.down`
- `.left`
- `.right`

新增：

```js
Vue.config.keyCodes.f1 = 112
```

### v-for

- (item, index) in list
- (value, key, index) in object
- count in 10，从 1 开始

### v-if、v-show

- 区别：if 没有这个元素，show 隐藏

## 过滤器 filter

- 只能在 `{{}}` 和 v-bind 中使用

```js
value | myfilter(param)
// 本地过滤器
filters: {myfilter: function (value, param) {}}
// 全局过滤器
Vue.filter('myfilter', function (value, param) {}
```

## 自定义指令 directive

```js
directives: {focus: {inserted: function (el) {el.focus()}}}
// 简写，相当于在 bind 和 update 中执行
directives: {focus: function (el) {el.focus()}}
```

回调函数：

- bind
- inserted
- update
- componentUpdated
- unbind

函数参数

- el
- binding
  - name
  - value
  - oldValue
  - expression
  - arg：:后面的值
  - modifiers：.后面的值
- vnode
- oldVnode

## 生命周期

- beforeCreate：data 和 methods 未初始化
- created

- beforeMount
- mounted
- beforeUpdate
- updated
- beforeDestroy
- destroyed

## vue-resource

```js
this.$http.get('url').then();
this.$http.post('url', {}, {emulateJSON: true}).then();
```

## 动画

### 过度动画

默认类名：

- v-enter-active
  - v-enter
  - v-enter-to
- v-leave-active
  - v-leave
  - v-leave-to
- v-move

示例：

```html
<transition name="my">
  <p v-if="show">hello</p>
</transition>

<style>
  .my-enter-active, .my-leave-active {
    transition: opacity .5s;
  }
  .my-enter, .my-leave-to {
    opacity: 0;
  }
</style>
```

### 动画

```html
<transition enter-active-class="animated enterClass" leave-active-class="animated leaveClass">
```

- 设置时间

```js
<transition :duration="1000">...</transition>
<transition :duration="{ enter: 500, leave: 800 }">...</transition>
```

> ***回调***

- before-enter/enter/after-enter/enter-cancelled
- leave
- done

> ***for 添加的元素***

- transition-group，:key，appear，tag="ul"

> ***过度模式***

- out-in

## 组件

> ***基本***

```js
var comp = Vue.extend(template: '');
Vue.component('myComp', comp);
// <my-comp></my-comp>
```

简化：

```js
// <template id="temp"></template>
Vue.component('myComp', {template: '#temp'});
```

- 数据 data 函数
- component :is

## 父子组件传值

### 数据

```html
// 1. 子组件v-bind
<child-comp v-bind:pvalue="value"></child-comp>
// 2. 子组件 props
props: ['pvalue']
```

### 方法

```html
// 1. 父组件方法 pfun
// 1. 子组件 v-on:cfun
<child-comp v-on:cfun="pfun"></child-comp>
// 3. 子组件 this.$emit('cfun')
```

## 获取元素 $refs

- ref

## 监听器 watch

```js
watch: {
  fieldame: function(newVal, oldVal){}
}
```

## 计算属性 computed

## vue-router

- 当前路由地址：$route.path

### 引入

```js
<script src="/path/to/vue.js"></script>
<script src="/path/to/vue-router.js"></script>

// 或者
import Vue from 'vue'
import VueRouter from 'vue-router'

Vue.use(VueRouter)
```

### 起步

```html
<div id="app">
  <router-link to="/foo">Go to Foo</router-link>
  <router-link to="/bar">Go to Bar</router-link>
  <router-view></router-view>
</div>

<script>
const Foo = { template: '<div>foo</div>' }
    const Foo = {template: '<div>foo</div>'};
    const Bar = {template: '<div>bar</div>'};

    const router = new VueRouter({
        routes: [
            {path: '/foo', component: Foo},
            {path: '/bar', component: Bar}
        ]
    });

    const app = new Vue({
        el: '#app',
        router: router
    });
</script>
```

> ***重定向***

```js
{path: '/', redirect: '/foo'}
```

> ***激活样式***

- 默认 router-link-active，可由构造选项 linkActiveClass 改变

### 传参

- $route.query
- 路径传参 `:foo`：$route.params

### 子路由

- children

### 命名路由

- components

```html
<router-view name="bar"></router-view>
<script>{path: '/', components: [default: Foo, bar: Bar]}</script>
```

## render

```js
render: function(createElement) {
  return createElement(comp)
}
```

## vue-loader

> ***安装***

```bash
npm i -D vue-loader vue-template-compiler
```

> ***配置***

```js
const VueLoaderPlugin = require('vue-loader/lib/plugin');
plugins: [
  new VueLoaderPlugin()
],
```

> ***.vue***

```html
<template>
	<div></div>
</template>
<script>
export default {
  data() {
    return {}
  }
}
</script>
<style scoped lang="less">
</style>
```

## Mint UI

### 安装

```bash
npm i mint-ui
```

### 引入全部

```js
import Vue from 'vue';
import Mint from 'mint-ui';
Vue.use(Mint);
```

### 按需引入

```js
import { Header } from 'mint-ui';
Vue.component(Header.name, Header);
```

> ***.babelrc***

```json
{
    "presets": [
      ["env", { "modules": false }]
    ],
    "plugins": [["component", [
      {
        "libraryName": "mint-ui",
        "style": true
      }
    ]]]
}
```

