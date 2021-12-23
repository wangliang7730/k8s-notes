---
date: 2021-10-19
updated: 2021-10-19
---

# 第1章 什么是JavaScript

## 1.1 简短的历史回顾

-   1995 年，网景工程师布兰登·艾奇（Brendan Eich）为 Netscape Navigator 2 开发一个叫 Mocha（后来改名为 LiveScript）的脚本语言
-   为了赶上发布时间，网景与 Sun 公司结为开发联盟，把 LiveScript 改名为 JavaScript
-   1997 年，JavaScript 1.1 作为提案被提交给欧洲计算机制造商协会（European Computer Manufacturers Association，Ecma），打造出 ECMA-262，也就是 ECMAScript（发音为“ek-ma-script”）
-   1998 年，国际标准化组织（ISO）和国际电工委员会（IEC）也将 ECMAScript 采纳为标准（ISO/IEC-16262）

## 1.2 JavaScript实现

完整的 JavaScript 实现包含以下几个部分：

-   核心（ECMAScript）
-   文档对象模型（DOM）
-   浏览器对象模型（BOM）

### 1.2.1 ECMAScript

-   并不局限于 Web 浏览器，Web 浏览器只是 ECMAScript 实现可能存在的一种宿主环境（host environment）
-   其他宿主环境还有服务器端 JavaScript 平台 Node.js 和即将被淘汰的 Adobe Flash

**【ECMA-262  版本】**

-   第 1 版本质上跟网景的 JavaScript 1.1 相同，只不过删除了所有浏览器特定的代码
-   第 2 版只是做了一些编校工作
-   第 3 版更新了字符串处理、错误定义和数值输出，增加了对正则表达式、新的控制语句、`try/catch` 异常处理的支持
-   第 4 版是对这门语言的一次彻底修订，跳跃太大了，在正式发布之前被放弃
-   第 5 版 2009 年发布，由 ECMAScript 3.1 演变而来，新增解析和序列化 JSON、严格模式
-   第 6 版，俗称 ES6、ES2015 或 ES Harmony（和谐版），于 2015 年 6 月发布，包含了大概这个规范有史以来最重要的一批增强特性。ES6 正式支持了类、模块、迭代器、生成器、箭头函数、期约、反射、代理和众多新的数据类型
-   第 7 版，也称为 ES7 或 ES2016，于 2016 年 6 月发布。这次修订只包含少量语法层面的增强，如 `Array.prototype.includes` 和指数操作符
-   第 8 版，也称为 ES8、ES2017，完成于 2017 年 6 月。增加了异步函数（`async/await`）、`SharedArrayBuffer` 及 `Atomics API`，以及 `Object.values()`/`Object.entries()`/`Object.getOwnPropertyDescriptors()` 和字符串填充方法，另外明确支持对象字面量最后的逗号
-   第 9 版，也称为 ES9、ES2018，发布于 2018 年 6 月。这次修订包括异步迭代、剩余和扩展属性、一组新的正则表达式特性、`Promise finally()`，以及模板字面量修订
-   第 10 版，也称为 ES10、ES2019，发布于 2019 年 6 月。这次修订增加了 `Array.prototype.flat()`/`flatMap()`、`String.prototype.trimStart()`/`trimEnd()`、`Object.fromEntries()` 方法，以及 `Symbol.prototype.description` 属性，明确定义了 `Function.prototype.toString()` 的返回值并固定了 `Array.prototype.sort()` 的顺序。另外，这次修订解决了与 JSON 字符串兼容的问题，并定义了 catch 子句的可选绑定

### 1.2.2 DOM

-   文档对象模型（DOM，Document Object Model）是一个应用编程接口（API），用于在 HTML 中使用扩展的 XML。
-   这个规范由两个模块组成：DOM Core 和 DOM HTML

**【DOM 级别】**

-   DOM Level 1 的目标是映射文档结构
-   DOM Level 2 的目标则宽泛得多，增加了对（DHTML 早就支持的）鼠标和用户界面事件、范围、遍历（迭代 DOM 节点的方法）的支持，而且通过对象接口支持了层叠样式表（CSS）
-   DOM Level 3 增加了以统一的方式加载和保存文档的方法（包含在一个叫 DOM Load and Save 的新模块中），还有验证文档的方法（DOM Validation）
-   目前，W3C 不再按照 Level 来维护 DOM 了，而是作为 DOM Living Standard 来维护，其快照称为DOM4。DOM4 新增的内容包括替代 Mutation Events 的 Mutation Observers。

### 1.2.3 BOM

-   浏览器对象模型（BOM） API，用于支持访问和操作浏览器的窗口

## 1.3 JavaScript版本

-   作为网景的继承者，Mozilla 是唯一仍在延续最初 JavaScript 版本编号的浏览器厂商

## 1.4 小结

-   JavaScript 是一门用来与网页交互的脚本语言，包含以下三个组成部分：
    -   ECMAScript：由 ECMA-262 定义并提供核心功能
    -   文档对象模型（DOM）：提供与网页内容交互的方法和接口
    -   浏览器对象模型（BOM）：提供与浏览器交互的方法和接口
-   JavaScript 的这三个部分得到了五大 Web 浏览器（IE、Firefox、Chrome、Safari 和 Opera）不同程度的支持
-   所有浏览器基本上对 ES5（ECMAScript 5）提供了完善的支持，而对 ES6（ECMAScript 6）和 ES7（ECMAScript 7）的支持度也在不断提升
-   这些浏览器对 DOM 的支持各不相同，但对 Level 3 的支持日益趋于规范
-   HTML5 中收录的 BOM 会因浏览器而异，不过开发者仍然可以假定存在很大一部分公共特性

