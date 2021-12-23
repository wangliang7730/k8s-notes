# Webpack

文档：https://webpack.docschina.org/guides/

## 概念

- [入口（entry）](https://webpack.docschina.org/concepts/#entry)
- [输出（output）](https://webpack.docschina.org/concepts/#output)
- [加载器（loader）](https://webpack.docschina.org/concepts/#loaders)
- [插件（plugin）](https://webpack.docschina.org/concepts/#plugins)
- [模式（mode）](https://webpack.docschina.org/concepts/#mode)

## 快速开始

安装：

```bash
# 创建项目
npm init -y
# 全局安装
npm i -g webpack webpack-cli
# 【推荐】开发依赖
npm i -D webpack webpack-cli
```

`src/data.json`：

```json
{
    "data": "Hello, Webpack!"
}
```

`src/index.js`：

```js
import data from './data.json'

let span = document.createElement("span")
document.body.appendChild(span)
span.textContent = JSON.stringify(data)v
```

执行：

```shell
webpack ./src/index.js
# 默认输出到 dist/main.js，可修改输出目录
-o dist
# 指定输出文件名
--output-filename bundle.js
# 可指定模式，默认 production
--mode=production|development
# 可处理 js 和 json 文件
index.html` 引入 `dist/main.js
```

用命令行指定参数太麻烦，引入 `webpack.config.js`：

```js
const { resolve } = require('path')

module.exports = {
  mode: 'development',
  entry: './src/index.js',
  output: {
    filename: 'bundle.js',
    // 需要传绝对路径
    path: resolve(__dirname, 'dist')
  },
}
```

>   ```
>   --config` 可以指定配置文件，默认 `webpack.config.js` 或 `webpackfile.js
>   ```
>
>   webpack 基于 nodejs，所以导入语法是 nodejs 方式

## css 处理

基本格式：

```js
module: {
  rules: [
    { test: /\.ext$/, loader: 'foo-loader' }, // 一个
    { test: /\.ext$/, use: 'foo-loader' }, // 一个
    { test: /\.ext$/, use: ['foo-loader', 'bar-loader'] }, // 多个
    { test: /\.ext$/, use: [ // 多个并配置选项
      { loader: 'foo-loader', options: {} },
      { loader: 'bar-loader', options: {} }
    ]}
  ]
}
```

>   loader 执行顺序从后往前

### css

```bash
npm i -D style-loader css-loader
module: {
  rules: [
    {
      test: /\.css$/i,
      use: [
        // 将 css 添加 head 标签中
        'style-loader',
        'css-loader'
      ]
    }
  ]
}
```

### less

```bash
npm i -D less less-loader
module: {
  rules: [
    {
      test: /\.less$/i,
      use: [
        'style-loader',
        'css-loader',
        'less-loader'
      ]
    }
  ]
}
```

### sass

```bash
npm i -D sass-loader node-sass
# npm config set sass_binary_site=https://npm.taobao.org/mirrors/node-sass
# npm i -D node-sass
module: {
  rules: [
    {
      test: /\.sass$/i,
      use: [
        'style-loader',
        'css-loader',
        'sass-loader'
      ]
    }
  ]
}
```

### css 压缩

optimize-css-assets-webpack-plugin

### css 兼容处理

post-css

## 资源文件处理

### file-loader

```bash
npm i -D file-loader
```

处理 CSS 中的 url

```js
{
  test: /\.(png|jpg|gif)$/i,
    loader: 'file-loader',
      options: {
        name: '[name].[ext]',
        outputPath: 'imgs'
      }
}
```

### url-loader

```bash
npm i -D url-loader
```

基于 file-loader，把图片转换成 base64

```js
{
  test: /\.(png|jpg|gif)$/i,
    loader: 'url-loader',
      options: {
        name: '[name].[ext]',
        limit: 8*1024
    }
}
```

### html-loader

```bash
npm i -D html-loader
```

处理 html 中的文件

```js
{
  test: /\.html$/i,
    loader: 'html-loader',
      options: {
        esModule: false
      }
}
```

>   报错：ERROR in Error: webpack://demo-webpack/./src/index.html?./node_modules/html-webpack-plugin/lib/loader.js:9 var **_HTML_LOADER_IMPORT_0\**_ = new URL(/\* asset import \*/\** webpack_require**(/*! ./user.png* / "./src/user.png"), **webpack_require**.b); ^ ReferenceError: URL is not defined
>
>   需要加 esModule: false

### html 压缩

## js 代码处理

### js 代码检查

es-lint

### js 兼容性

babel-loader：

```bash
npm i -D babel-loader @babel/core @babel/cli @babel/preset-env

#npm i -D babel-core babel-loader babel-plugin-transform-runtime
#npm i -D babel-preset-env babel-preset-stage-0

#npm i -D babel-loader@7 babel-core babel-preset-env
{
  test: /\.js$/, 
  use: {
    loader: 'babel-loader',
    options: {
      presets: ['@babel/env'],
      plugins: ['@babel/plugin-proposal-class-properties']
    }
  },
  exlude: /noe_modules/
}
```

>   ***.babelrc\***

```json
{
  "presets": ["env", "stage-0"],
  "plugins": ["transform-runtime"]
}
```

### js 压缩

## 插件

### [webpack-dev-server](https://webpack.docschina.org/configuration/dev-server/)

```bash
npm i -D webpack-dev-server
devServer: {
  port: 9000,
  // 启动后打开
  open: true,
  // 详细搜索HMR
  hot: true
}
webpack serve
```

### html-webpack-plugin

```bash
npm i -D html-webpack-plugin
const htmlWebpackPlugin = require('html-webpack-plugin')

output: {
  // hash
  path: path.join(__dirname, './dist'),
    filename: 'bundle.[hash:8].js'
},
plugins: [
  // 会创建 index.html，并引入入口 js
  new HtmlWebpackPlugin(
    {
      // 指定模板
      template: './src/index.html',
      hash: true,
      minify: {
        removeAttributeQuotes: true,
        collapseWhitespace: true,
      }
    }
  )
]
```

### mini-css-extract-plugin

```bash
npm i -D mini-css-extract-plugin
const MiniCssExtractPlugin = require('mini-css-extract-plugin');

new MiniCssExtractPlugin({
  filename: 'index.css'
})

{
  test: /\.css$/i,
    use: [
      // style-loader 替换为
      MiniCssExtractPlugin.loader,
      'css-loader'
    ]
}
```

>   报错：Error: Automatic publicPath is not supported in this browser
>
>   需要指定 `publicPath`：
>
>   ```js
>   output: {
>       path: resolve(__dirname, 'dist'),
>       publicPath: ''
>   }
>   ```

### clean-webpack-plugin

```bash
npm i -D clean-webpack-plugin
const { CleanWebpackPlugin } = require('clean-webpack-plugin');

plugins: [
  new CleanWebpackPlugin(),
]
```

## resolve

```js
resolve: {
  alias: {
    'vue$': 'vue/dist/vue.js'
  }
}
```

