# Node.js

## 工具

### npm

```shell
npm i -g nrm --registry https://registry.npm.taobao.org # 临时设置镜像
npm config set registry https://registry.npm.taobao.org # 永久设置镜像，会在 ~/.npmrc 配置
npm config get registry # 获取镜像设置
npm init -y # 初始化

# 安装
npm i
npm i -S, --save # 运行依赖
npm i -D ,--save-dev # 开发依赖
npm i -g ,--global # 全局安装
npm i 包名@版本 # 安装指定版本

# 查看
npm view 包名 # 查看包信息
npm view 包名 versions # 查看所有版本
npm view 包名 version # 查看最新版本
npm ls 包名 # 查看已安装版本

npm uninstall # 卸载
npm update # 更新
npm root -g # 查看全局安装位置

# 发布
npm config set registry http://registry.npmjs.org # 切换源，或者 nrm use npm
npm login # 登录
npm publish # 发布，注册后需要验证邮箱，否则报错
npm config set registry https://registry.npm.taobao.org # 切换回来，或者 nrm use taobao
```

**版本指定：**

- ^1.x.x # 锁定大版本
- ~1.1.x # 锁定次版本
- 1.1.1 # 明确版本

### nvm

全称：**Node Version Manager**，Node 版本管理

下载：https://github.com/coreybutler/nvm-windows/releases

```shell
nvm root # 查看根目录
nvm node_mirror https://npm.taobao.org/mirrors/node/ # 设置node镜像，会修改<root>/settings.txt中的配置
nvm npm_mirror https://npm.taobao.org/mirrors/npm/ # 设置npm镜像
nvm list # 查看已安装版本
nvm list available # 查看可安装版本
nvm install latest # 安装最新版本node
nvm install 版本 # 安装指定版本
nvm uninstall 版本 # 卸载指定版本
nvm use 版本 # 使用指定版本
```


### nrm

```bash
npm i -g nrm@1.1.0 # 安装
nrm ls # 列出所有镜像
nrm test # 测试镜像速度
nrm use
```

>   报错：https://github.com/Pana/nrm/issues/82

### npx

```bash
--no-install # 不要自动安装，默认没有会自动安装
```

### yarn

```bash
yarn config set registry https://registry.npm.taobao.org -g
yarn config set sass_binary_site http://cdn.npm.taobao.org/dist/node-sass -g
yarn init # 初始化
yarn install # 安装
yarn global add # 全局安装
yarn add # 运行依赖
yarn add --dev # 开发依赖
yarn remove # 卸载
yarn global remove # 全局卸载
```

## 程序入口

每个文件都被包在函数内：

```js
console.log(arguments.callee.toString())
// 输出可以看见实际发生了下面的调用
function (exports, require, module, __filename, __dirname) {
  console.log(arguments.callee.toString())
}
```

## 模块化

- 重复的只加载一次
- `module.exports` 为导出的对象
- `exports = module.exports`，所以 `exports = {}` 后的 `exports` 将会失效
- 相对路径不能省略 `./`

## [解析顺序](http://nodejs.cn/api/modules.html#modules_all_together)

- 核心模块
- [node_modules](http://nodejs.cn/api/modules.html#modules_loading_from_node_modules_folders)
- 父目录 node_modules
- 环境变量 [NODE_PATH](http://nodejs.cn/api/modules.html#modules_loading_from_the_global_folders)

## 全局变量

```js
// 类比浏览器的 window
console.log(global)
// this 指向空对象 {}
console.log(this)
```

## 事件循环机制

```js
process.nextTick()
setImmediate()
setTimeout()
```

## 事件

```js
const Events = require('events');
class MyEvent extends Events {
}
let myEvent = new MyEvent();
myEvent.on('hehe', function() {
    console.log('呵呵');
});
myEvent.once('hehe', function() {
    console.log('呵呵');
});
myEvent.emit('hehe');
```

## 调试

>   **TODO**

## http

### 创建服务

```js
const http = require('http')

const hostname = '127.0.0.1'
const port = 3000

const server = http.createServer((req, res) => {
    res.statusCode = 200
    res.setHeader('Content-Type', 'text/plain')
    res.end('Hello\n')
})

server.listen(port, hostname, () => {
    console.log(`server start: http://${hostname}:${port}/`)
})
```

### [url](http://nodejs.cn/api/url.html) 解析

**过时的方式**

```js
const url = require('url');
const myURL = url.parse('https://user:pass@sub.host.com:8080/p/a/t/h?query=string#hash');
// Url {
//     protocol: 'https:',       
//     slashes: true,
//     auth: 'user:pass',        
//     host: 'sub.host.com:8080',
//     port: '8080',
//     hostname: 'sub.host.com',
//     hash: '#hash',
//     search: '?query=string',
//     query: 'query=string',
//     pathname: '/p/a/t/h',
//     path: '/p/a/t/h?query=string',
//     href: 'https://user:pass@sub.host.com:8080/p/a/t/h?query=string#hash'
// }
```

**WHATWG 标准：**

```js
const myURL = new URL('https://user:pass@sub.host.com:8080/p/a/t/h?query=string#hash');
// URL {
//     href: 'https://user:pass@sub.host.com:8080/p/a/t/h?query=string#hash',
//     origin: 'https://sub.host.com:8080',
//     protocol: 'https:',
//     username: 'user',
//     password: 'pass',
//     host: 'sub.host.com:8080',
//     hostname: 'sub.host.com',
//     port: '8080',
//     pathname: '/p/a/t/h',
//     search: '?query=string',
//     searchParams: URLSearchParams { 'query' => 'string' },
//     hash: '#hash'
// }
```

### GET 参数

#### 解析

```js
const querystring = require('querystring')
let params = querystring.parse(req.url.split('?')[1])
```

#### 序列化

```js
querystring.stringify({ foo: 'bar', hehe: '呵呵' })
// foo=bar&hehe=%E5%91%B5%E5%91%B5
```

### POST 参数

```js
let chunks = []
let length = 0
req.on('data', function (chunk) {
    chunks.push(chunk)
    length += chunk.length
})
req.on('end', function () {
    let data = Buffer.concat(chunks, length)
    let params = querystring.parse(data.toString())
    res.end()
})
```

## Express

### 创建

```js
const express = require('express')
const app = express()

app.get('/', function (req, res) {
    res.send('hello')
})

app.listen(3000, function (err) {
    console.log('服务启动成功：http://127.0.0.1:3000')
})
```

### 请求

```js
// 请求路径
req.url
// url查询参数对象
req.query
// 路径参数 :id
req.params
// 请求体
request.body
// 请求头
request.get()
```

### 响应

```js
// 会自动设置响应头，只能调用一次
res.send()
res.end()
// 下载文件，相对路径
res.download()
// 发送文件，绝对路径
res.sendFile()
res.redirect()
// 设置响应头
res.set()
// 获取设置过的响应头
res.get()
// 设置响应码
res.status()
```

>   **发送文件和下载文件的区别：**浏览器能识别文件则直接渲染，不能识别再下载

### body-parser

### 中间件

```js
// 全局中间件
app.use((req, res, next) => {next()})
// 路由器中间件
app.get('/', (req, res, next) => {})
app.use('/', (req, res, next) => {})
app.get('/', (req, res, next) => {}, (req, res) => {})
```

### body-parser

```js
const bodyParser = require('body-parser')
app.use(bodyParser.urlencoded({
    // false 使用自带方式解析，true 使用 qs 模块解析
    extended: false
 }))
// parse application/json
app.use(bodyParser.json())

// 内置的 parser
app.use(express.urlencoded())
```

### 静态资源

```js
app.use(express.static('/path'))
// 指定路径
app.use("/path", express.static('/path'))
```

### 路由

```js
const router = express.Router()
router.get('/', (req, res) => {})
module.exports = router

var router = require('router')
app.use(router)
app.use('/path', router)
```

## cors

```js
const cors = require('cors')
app.use(cors())
```

## bcryptjs

```js
const bcryptjs = require('bcryptjs')
const password = '123456'
const hashPassword = bcryptjs.hashSync(password, 10)
bcryptjs.compareSync(password, '$2a$10$P8x85FYSpm8xYTLKL/52R.6MhKtCwmiICN2A7tqLDh6rDEsrHtV1W')
```



## mysql

```js
const mysql = require('mysql');

const db = mysql.createPool({
    host: '127.0.0.1',
    user: 'root',
    password: 'root',
    database: 'tmp'
})
```

## [mongoose](https://mongoosejs.com/)

### [连接](http://www.mongoosejs.net/docs/connections.html)

```js
// 连接
mongoose.connect('mongodb://192.168.100.100:27017', {
    useNewUrlParser: true,
    useUnifiedTopology: true
})

// 回调
mongoose.connection.on('connected', function () {
    console.log('连接成功')
});
mongoose.connection.on('disconnected', function () {
    console.log('连接断开')
});

// 关闭
mongoose.connection.close()
```

### [Schema](http://www.mongoosejs.net/docs/schematypes.html)

```js
var schema = new mongoose.Schema({
  name:    String,
  binary:  Buffer,
  living:  Boolean,
  updated: { type: Date, default: Date.now },
  age:     { type: Number, min: 18, max: 65 },
  mixed:   Schema.Types.Mixed,
  _someId: Schema.Types.ObjectId,
  decimal: Schema.Types.Decimal128,
  array:      [],
  ofString:   [String],
  ofNumber:   [Number],
  ofDates:    [Date],
  ofBuffer:   [Buffer],
  ofBoolean:  [Boolean],
  ofMixed:    [Schema.Types.Mixed],
  ofObjectId: [Schema.Types.ObjectId],
  ofArrays:   [[]],
  ofArrayOfNumbers: [[Number]],
  nested: {
    stuff: { type: String, lowercase: true, trim: true }
  }
})
```

***添加方法：\***

```js
kittySchema.methods.speak = function () {
  console.log("my name is" + this.name);
}
```

### Model

```js
var FooModal = mongoose.model('集合名', schema);
var foo = new FooModal({})

// 应该可以不用等连接成功就调用下面这些方法，因为它们方法本身就是异步的

// 增
foo.save(function(err, data))
// 或者
FooModal.create({}, function(err, data))

// 删
FooModal.deleteOne({条件}, function(err, data))
FooModal.deleteMany({条件}, function(err, data))

// 改
FooModal.update({条件},{},function(err, data))
FooModal.updateOne({条件},{},function(err, data))
FooModal.updateMany({条件},{},function(err, data))

// 查
FooModal.find({}, function(err, data))
FooModal.findOne({}, function(err, data))
```

## log4js

**快速开始：**

```js
var log4js = require("log4js");
var logger = log4js.getLogger();
logger.level = "debug";
logger.debug("Some debug messages");
```

**配置：**

```js
const log4js = require('log4js');
log4js.configure({
    appenders: {
        'consoleAppender': { type: 'console' },
        'fileAppender': { type: 'file', filename: 'file.log' }
    },
    categories: {
        default: {
            appenders: ['consoleAppender', 'fileAppender'],
            level: 'all'
        },
        consoleLogger: {
            appenders: ['consoleAppender'],
            level: 'info'
        },
        fileLogger: {
            appenders: ['fileAppender'],
            level: 'error'
        },
    }
});

let logger = log4js.getLogger();
logger.trace('trace');
logger.debug('debug');
logger.info('info');
logger.warn('warn');
logger.error('error');
logger.fatal('fatal');

logger = log4js.getLogger('consoleLogger');
logger.trace('trace');
logger.debug('debug');
logger.info('info');
logger.warn('warn');
logger.error('error');
logger.fatal('fatal');

logger = log4js.getLogger('fileLogger');
logger.trace('trace');
logger.debug('debug');
logger.info('info');
logger.warn('warn');
logger.error('error');
logger.fatal('fatal');
```