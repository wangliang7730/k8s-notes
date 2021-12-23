# JavaScript

## 加载

### `defer` 和 `async` 的区别

- `defer` 保证顺序，`async` 无序
- 有 `defer` 属性的脚本会阻止 `DOMContentLoaded` 事件，直到脚本被加载并且解析完成

![20210220233046](assets/20210220233046.png)

### 脚本加载

```js
let script = document.createElement('script');
script.src = 'gibberish.js';
script.async = true;
document.head.appendChild(script);
```

### 加载事件

按照先后顺序：

1.  DOM 数加载完毕 `DOMContentLoaded`
2.  加载完图片等资源 `window.onload`

```js
document.addEventListener("DOMContentLoaded", function () {
  console.log('document.DOMContentLoaded')
});

window.onload = function () {
  console.log('window.onload')
}

$(function () {
  console.log("$()")
});

$(document).ready(function () {
  console.log('$(document).ready()')
})
// 输出
// document.DOMContentLoaded
// window.onload
// $()
// $(document).ready()
```

## 变量

### `var` 与 `let` 的区别

| 区别           | var                   | let                  |
| -------------- | --------------------- | -------------------- |
| 作用域         | 函数                  | 块                   |
| 声明前使用     | 作用域提升，undefined | 暂时性死区，报错     |
| 重复声明       | 覆盖                  | 报错                 |
| 全局作用域声明 | 成为 window 属性      | 不会成为 window 属性 |

### `for` 循环中的 `var` 与 `let`

```js
for (var i = 0; i < 5; ++i) {
    setTimeout(() => console.log(i), 0)
}
// 输出：5 5 5 5 5

for (let i = 0; i < 5; ++i) {
    setTimeout(() => console.log(i), 0)
}
// 输出：0 1 2 3 4
```

### `const`

- 和 `let` 类似，但是不能修改值，可以修改引用内的值
- 引用内的值也不想修改时，用 `Object.freeze`

>   **建议：**
>
>   1.  不使用 `var`
>   2.  `const` 优先，`let` 次之

## 作用域

### 欺骗词法

`js` 之前只能用 `var`，没有块作用域，`let` 出现没他们什么事了：

- `with` 会添加当前对象到作用域链，具有块作用域
- `catch` 具有块作用域
- `eval` 非严格模式在其所在的作用域，严格模式在其内部作用域

### `this` 的作用域

箭头函数的 `this` 只指向定义它的上下文对象，`call` 等不能改变

## 数据类型

### 分类

有 7 种简单类型（也称原始类型）：

- `Undefined`：只有一个值 `undefined`
- `Null`：只有一个值 `null`
- `Boolean`：只有 `true` 和 `false`
- `Number`
- `String`
- `Symbol`
- `BigInt`

1 种复杂数据类型：

- `Object`

### `typeof` 操作符

- 除了 `null`，返回对应小写开头的数据类型
- `null` 认为是空对象，所以 `typeof(null)` 返回 `object`
- 函数严格来讲是 `Object`，但是会返回 `function`
- `typeof` **未赋值**和**未声明**的变量都返回 `undefined`

### `instanceof` 操作符

- 对象类型需要使用 `instanceof` 确定是否是某个类型

### `undefined` 和 `null` 类型

`undefined` 是 `null` 派生来的，所以

```js
undefined == null // true
undefined === null // false
```

### `Boolean` 类型

**转换规则：**

| 数据类型    | 转换为 `true`    | 转换为 `false` |
| ----------- | ---------------- | -------------- |
| `String`    | 非空             | `""` 空字符串  |
| `Number`    | 非零（包括无穷） | `±0`、`NaN`    |
| `Object`    | 非 `null`        | `null`         |
| `Undefined` | -              | `undefined`    |

### `Number` 类型

**特殊值：**

- `+0`、`-0`
- `+Infinity`、`-Infinity`
- `NaN`

**转换规则：**

- 布尔值，`true` 为 1，`false` 为 0
- `null` 为 0
- `undefined` 为 `NaN`
- 字符串
    - 空字符串返回 0
    - 数值 `0x` 开头十六进制，否则十进制
    - 包含其他字符 `NaN`
- 对象调用 `valueOf`，再转换

>   `Number` 只能包含数字，`parseInt` 数字开头就行

### `String` 类型

#### 模板字符串

```js
`${表达式}`
```

#### 标签函数

```js
// 模板字符串前加上标签函数名
let ret = tagFun`${a} + ${b} = ${a + b}`
// 调用时会把间隔的字符串和变量值传入
function tagFun(strings, ...expressions) {
  // strings 为 ${} 分割的字符串数组
  // expressions 为 ${} 中的每个表达式的值
}
```

**用标签函数实现默认字符串拼接功能：**

```js
function noTag(strings, ...expressions) { 
  return strings[0] + expressions.map((e, i) => `${e}${strings[i + 1]}`).join(''); 
}
```

#### 原始字符串

```js
console.log('\u00A9')
// 输出 ©

console.log(String.raw`\u00A9`)
// 输出 \u00A9
```

>   注意：调用时没用括号

### Symbol 类型

#### 新建

```js
// 新建，每个都不一样
let s = Symbol()
let s1 = Symbol('desc') // 只做为描述
```

>   不能 `new Symbol()`，避免创造包装对象，`BigInt` 也不能 `new`。不用 `new` 时，返回的是基本类型，用 `new` 返回的是包装类型，比如：
>
>   ```js
>   typeof(Number(1)) // number
>   typeof(new Number(1)) // object
>   ```
>
>   可以用 `Object(Symbol())` 包装

#### 全局符号

```js
let s = Symbol.for('key') // 作为键，相同的key返回同一个
let key = Symbol.keyFor(s) // 获取key 
```

#### 作为属性

```js
o = {[fooSymbol]: ''} // 加中括号，否则认为是string
o[fooSymbol] = ''

Object.getOwnPropertyNames() // 不返回Symbol
Object.getOwnPropertySymbols() // 只返回Symbol
Object.getOwnPropertyDescriptors() // 返回所有
Reflect.ownKeys() // 返回所有
```

#### 内置符号

- Symbol.asyncIterator
- Symbol.hasInstance
- Symbol.isConcatSpreadable
- Symbol.iterator
- Symbol.match
- Symbol.replace
- Symbol.search
- Symbol.species
- Symbol.split
- Symbol.toPrimitive
- Symbol.toStringTag
- Symbol.unscopables

### BigInt 类型

- 字面值可加 `n` 后缀表示：10n

## JavaScript - 运算符

### 移位

- `>>` 有符号右移
- `>>>` 无符号右移

### 没有整除

- `Math.floor()`

### 指数

- `**`

### 相等和全等

- 如果任一操作数是布尔值，则将其转换为数值再比较是否相等。`false` 转换为 0，`true` 转换为 1
- 如果一个操作数是字符串，另一个操作数是数值，则尝试将字符串转换为数值，再比较是否相等
- 如果一个操作数是对象，另一个操作数不是，则调用对象的 `valueOf()` 方法取得其原始值，再根据前面的规则进行比较

```js
null == undefined
null !=== undefined
```

### `for-in` 和 `for-of`

- `for-in` 遍历键名
- `for-of` 遍历键值

```js
for (const [idx, element] of array)
```

### `with`

```js
with (location) {
  // location加入到作用域上下文中
}
```

## 函数

### [`bind()`](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Function/bind)

`bind()` 方法创建一个新的函数，在 `bind()` 被调用时，这个新函数的 `this` 被指定为 `bind()` 的第一个参数，而其余参数将作为新函数的参数，供调用时使用。

**语法：**

```js
function.bind(thisArg[, arg1[, arg2[, ...]]])
```

**返回值：**

返回一个原函数的拷贝，并拥有指定的 **`this`** 值和初始参数。

### [`call()`](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Function/call)

`call()` 方法使用一个指定的 `this` 值和单独给出的一个或多个参数来调用一个函数。

>   **注意：**该方法的语法和作用与 `apply()` 方法类似，只有一个区别，就是 `call()` 方法接受的是**一个参数列表**，而 `apply()` 方法接受的是**一个包含多个参数的数组**。

**语法：**

```js
function.call(thisArg, arg1, arg2, ...)
```

### [`apply()`](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Function/apply)

**`apply()`** 方法调用一个具有给定`this`值的函数，以及以一个数组（或[类数组对象](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Guide/Indexed_collections#Working_with_array-like_objects)）的形式提供的参数。

>   **注意：**`call()` 方法的作用和 `apply()` 方法类似，区别就是`call()`方法接受的是**参数列表**，而`apply()`方法接受的是**一个参数数组**。

**语法：**

```js
function.apply(thisArg, [argsArray])
```

### 区别

- `call()` 和 `apply()` 就传参方式不一样，似乎没有本质区别
- `bind()` 感觉是对 `call()` 的加强，可以缓存 `this`，后续再调用

### 应用

### 伪数组转换为数组

可以通过 `Array.prototype.slice.call(likeArray)` 将伪数组转换为数组，其中伪数组是：

- 能通过下标访问元素 `likeArray[i]`
- 有 `length` 属性

比如 `DOM`、`arguments`、`{0: 'foo', length: 1}` 等

>   原理是大致是因为 `splice` 会新建一个数组，然后遍历 `push`

### 获取对象类型

```js
function type (obj) {
   return Object.prototype.toString.call(obj);
}
```

### 用于继承

### 手动实现 `call()` 和 `apply()`

临时构造一个对象，让 `call()` 和传入的参数都在里面，这时候调用 `call()`，`this` 指针不就指向被调用的参数了

```js
Function.prototype.myCall = function (context) {
    // 赋值作用域参数，如果没有则默认为 window，即访问全局作用域对象
    context = context || window    
    // 绑定调用函数（.call之前的方法即this，前面提到过调用call方法会调用一遍自身，所以这里要存下来）
    context.invokFn = this    
    // 截取作用域对象参数后面的参数
    let args = [...arguments].slice(1)
    // 执行调用函数，记录拿取返回值
    let result = context.invokFn(...args)
    // 销毁调用函数，以免作用域污染
    Reflect.deleteProperty(context, 'invokFn')
    return result
}

Function.prototype.myApply = function (context) {
    // 赋值作用域参数，如果没有则默认为 window，即访问全局作用域对象
    context = context || window
    // 绑定调用函数（.call之前的方法即this，前面提到过调用call方法会调用一遍自身，所以这里要存下来）
    context.invokFn = this
    // 执行调用函数，需要对是否有参数做判断，记录拿取返回值
    let result
    if (arguments[1]) {
        result = context.invokFn(...arguments[1])
    } else {
        result = context.invokFn()
    }
    // 销毁调用函数，以免作用域污染
    Reflect.deleteProperty(context, 'invokFn')
    return result
}
```

### 手动实现 `bind()`

>   **TODO**

## 对象

### `Object`

```js
Object.getOwnPropertyNames() // 不返回Symbol
Object.getOwnPropertySymbols() // 只返回Symbol
Object.getOwnPropertyDescriptors() // 返回所有
```

### `Object.prototype`

```js
constructor
hasOwnProperty(propertyName)
isPrototypeOf(object)
propertyIsEnumerable(propertyName) // 是否可用for-in循环
toLocaleString()
toString()
valueOf()
```

### `new` 内部过程

1.  在内存中创建一个新对象
2.  这个新对象内部的 [Prototype](app://obsidian.md/Prototype) 特性被赋值为构造函数的 prototype 属性
3.  构造函数内部的 this 被赋值为这个新对象（即 this 指向新对象）
4.  执行构造函数内部的代码（给新对象添加属性）
5.  如果构造函数返回非空对象，则返回该对象；否则，返回刚创建的新对象

## 原型

### 相关方法

- Object.setPrototypeOf() 可以设置原型对象，影响代码性能
- Object.getPrototypeOf()
- Object.create() 创建时指定原型对象
- Object.hasOwnProperty() 是否本身属性，`in` 包括原型

### 原型链

![UfXRZ](assets/UfXRZ.png)

## 参考

- [defer和async的区别](https://segmentfault.com/q/1010000000640869)
- [JS异步加载的三种方式](https://blog.csdn.net/l522703297/article/details/50754695)
- [深入理解JS中声明提升、作用域（链）和`this`关键字](https://github.com/creeperyang/blog/issues/16)

- [Symbol、BigInt不能new，而String、Number可以new，为什么？](http://www.zuo11.com/blog/2019/12/new_check.html)

- [javascript中call()、apply()、bind()的用法终于理解](https://www.cnblogs.com/Shd-Study/p/6560808.html)
- [让你弄懂 call、apply、bind的应用和区别](https://juejin.cn/post/6844903567967387656)
- [如何理解和熟练运用 JS 中的 call 及 apply？](https://www.zhihu.com/question/20289071/answer/93261557)
- [call、apply、bind的原理剖析及实现](https://www.cnblogs.com/zhazhanitian/p/11400898.html)

- [__proto__ VS. prototype in JavaScript](https://stackoverflow.com/questions/9959727/proto-vs-prototype-in-javascript)