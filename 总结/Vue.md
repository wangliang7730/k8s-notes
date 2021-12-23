# Vue

## 快速开始

```html
<script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>
<div id="app">
  {{ message }}
</div>
<script>
  var app = new Vue({
    el: '#app',
    data: {
      message: 'Hello Vue!'
    }
  })
</script>
```

## Vue 实例

当一个 Vue 实例被创建时，它将 `data` 对象中的所有的 property 加入到 Vue 的响应式系统中

```js
let obj = {
  foo: 'bar'
}

let vm = new Vue({
  el: '#app',
  data: obj
})

// vm.foo == obj.foo
// 创建之后添加的数据不会绑定
// 另外实例的一些内置属性加了$，比如vm.$data === obj
```

>   不要在属性的函数传参上使用箭头函数，因为箭头函数的 `this` 问题

## 生命周期

![lifecycle](assets/lifecycle.png)

## 插值

### 文本

文本插值，可以使用 JavaScript 表达式，支持 [全局变量的一个白名单](https://github.com/vuejs/vue/blob/v2.6.10/src/core/instance/proxy.js#L9)

```html
<span>Message: {{ msg }}</span>
```

### html

```html
<div v-html="html"></div>
```

>   数据变动视图也会变，可以用 `v-once` 限定只渲染一次

## 计算属性

**默认 gettter：**

```js
computed: {
  fullName: function () {
    return this.firstName + ' ' + this.lastName
  }
}
```

>   计算属性会缓存，如果依赖的属性不变不会重新计算

**可以指定 setter：**

```js
computed: {
  fullName: {
    // getter
    get: function () {
      return this.firstName + ' ' + this.lastName
    },
    // setter
    set: function (newValue) {
      var names = newValue.split(' ')
      this.firstName = names[0]
      this.lastName = names[names.length - 1]
    }
  }
}
```

## 侦听器

```js
watch: {
  // 如果 foo 发生改变，这个函数就会运行
  foo: function (newValue, oldValue) {
  }
}
```

## 过滤器

```java
filters: {
  capitalize: function (value) {
  }
}
```

## 指令

### 动态参数

```html
<a v-bind:[attributeName]="url">...</a>
```

### 修饰符

```html
<form v-on:submit.prevent="onSubmit">...</form>
```

### 简写

- `v-bind:` 简写为 `:`
- `v-on:` 简写为 `@`

## v-cloak

在结束编译之前一直存在，编译后会移除这个属性，所以可以在编译时隐藏，防止闪屏

```html
<div v-cloak>
  {{ message }}
</div>
<style>
[v-cloak] {
  display: none;
}
</style>
```

## Class 绑定

```html
<!-- 对象 -->
<div v-bind:class="{ active: isActive }"></div>
<!-- 数组 -->
<div v-bind:class="[activeClass, errorClass]"></div>
```

## Style 绑定

```html
<!-- 对象 -->
<div v-bind:style="{ color: activeColor, fontSize: fontSize + 'px' }"></div>
<!-- 数组 -->
<div v-bind:style="[baseStyles, overridingStyles]"></div>
```

## 条件渲染

### `v-if`

```html
<!-- 中间不能有其他元素 -->
<div v-if="type === 'A'">A</div>
<div v-else-if="type === 'B'">B</div>
<div v-else-if="type === 'C'">C</div>
<div v-else>Not A/B/C</div>

<!-- 分组，template 本身不显示 -->
<template v-if="ok">
  <h1>Title</h1>
  <p>Paragraph 1</p>
  <p>Paragraph 2</p>
</template>
```

>   不添加 `key` 属性，条件渲染的元素可能会被复用

### `v-show`

```html
<!-- 会渲染到DOM中，只是会改变display属性 -->
<h1 v-show="ok">Hello!</h1>
```

### `v-if` 和 `v-show` 的区别

- `v-if` 是有和无这个 DOM 元素
- `v-show` 始终有这个 DOM 元素，只是显示与否的问题

所以频繁切换 `v-show`，否则用 `v-if`

## 列表渲染

```html
<!-- 列表，可以用 of 代替 in -->
<ul id="example-2">
  <!-- 指定 key 标识 -->
  <li v-for="(item, index) in items" :key="index">
    {{ parentMessage }} - {{ index }} - {{ item.message }}
  </li>
</ul>

<!-- 对象，按 Object.keys() 遍历 -->
<div v-for="(value, name, index) in object">
  {{ index }}. {{ name }}: {{ value }}
</div>

<!-- 数字 -->
<div>
  <span v-for="n in 10">{{ n }} </span>
</div>
```

>   - `v-for` 的优先级比 `v-if` 更高，意味着是循环中判断
>   - 类似 `v-if` 也可用 `<template>` 标签渲染一个组
>   - [数组更新检测](https://cn.vuejs.org/v2/guide/list.html#数组更新检测)

## 事件处理

```html
<!-- 表达式 -->
<button v-on:click="counter += 1">Add 1</button>
<!-- 方法名 -->
<button v-on:click="greet">Greet</button>
<!-- 自己调用 -->
<button v-on:click="say('hi', $event)">Say hi</button>
```

### 事件修饰符

- `.stop`
- `.prevent`
- `.capture`
- `.self`
- `.once`
- `.passive`

可以串联

>   使用修饰符时，顺序很重要；相应的代码会以同样的顺序产生。因此，用 `v-on:click.prevent.self` 会阻止**所有的点击**，而 `v-on:click.self.prevent` 只会阻止对元素自身的点击。

### 按键修饰符

可以使用 [`KeyboardEvent.key`](https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent/key/Key_Values) 按键名的短横线名称

```html
<!-- 只有在 key 是 Enter 时调用 vm.submit() -->
<input v-on:keyup.enter="submit">
```

别名：

- `.enter`
- `.tab`
- `.delete` (捕获“删除”和“退格”键)
- `.esc`
- `.space`
- `.up`
- `.down`
- `.left`
- `.right`

## 数据绑定

>   `v-model` 会忽略所有表单元素的 `value`、`checked`、`selected` attribute 的初始值而总是将 Vue 实例的数据作为数据来源。你应该通过 JavaScript 在组件的 `data` 选项中声明初始值。

`v-model` 在内部为不同的输入元素使用不同的 property 并抛出不同的事件：

- text 和 textarea 元素使用 `value` property 和 `input` 事件；
- checkbox 和 radio 使用 `checked` property 和 `change` 事件；
- select 字段将 `value` 作为 prop 并将 `change` 作为事件。

## 组件