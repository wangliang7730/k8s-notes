# Babel

***参考：***

- [阮一峰 - Babel 入门教程](http://www.ruanyifeng.com/blog/2016/01/babel.html)

## 开始

### 配置

```bash
# ES2015转码规则
$ npm install --save-dev babel-preset-es2015

# react转码规则
$ npm install --save-dev babel-preset-react

# ES7不同阶段语法提案的转码规则（共有4个阶段），选装一个
$ npm install --save-dev babel-preset-stage-0
$ npm install --save-dev babel-preset-stage-1
$ npm install --save-dev babel-preset-stage-2
$ npm install --save-dev babel-preset-stage-3
```

*`.babelrc`*

```json
{
    "presets": [
    "es2015",
    "react",
    "stage-2"
    ],
	"plugins": []
}
```

### 命令行

***全局：***

```bash
$ npm install --global babel-cli
```

```bash
# 转码结果输出到标准输出
$ babel example.js

# 转码结果写入一个文件
# --out-file 或 -o 参数指定输出文件
$ babel example.js --out-file compiled.js
# 或者
$ babel example.js -o compiled.js

# 整个目录转码
# --out-dir 或 -d 参数指定输出目录
$ babel src --out-dir lib
# 或者
$ babel src -d lib

# -s 参数生成source map文件
$ babel src -d lib -s
```

***非全局：***

```bash
$ npm install --save-dev babel-cli
```

*`package.json`*

```javascript
{
  // ...
  "devDependencies": {
    "babel-cli": "^6.0.0"
  },
  "scripts": {
    "build": "babel src -d lib"
  },
}
```

```javascript
$ npm run build
```