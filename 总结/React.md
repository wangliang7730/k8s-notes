# React

## 快速开始

```html
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8" />
    <title>Hello React!</title>
    <script src="https://cdn.staticfile.org/react/16.4.0/umd/react.development.js"></script>
    <script src="https://cdn.staticfile.org/react-dom/16.4.0/umd/react-dom.development.js"></script>
    <script src="https://cdn.staticfile.org/babel-standalone/6.26.0/babel.min.js"></script>
</head>

<body>

    <div id="app"></div>
    <script type="text/babel">
        const element = <h1>Hello,world!</h1>;
        ReactDOM.render(
            element,
            document.getElementById('app')
        );
    </script>

</body>

</html>
```

## JSX

```jsx
const h1 = (<h1>{name}</h1>);
```

- 本质上 JSX 会调用 `React.createElement`
- 大括号 `{}` 内写 `JavaScript` 表达式
- 括号包起来避免[自动插入分号](http://stackoverflow.com/q/2846283)
- 属性名驼峰命名，class 为 `className`
- style 用对象赋值 `style={{key:value}}`
- 只能一个根标签，标签必须结束
- 小写字母开头为 html 标签，大写字母开头为组件

## 组件

### 函数式组件

```jsx
function MyComponent() {
  return <h1>foo</h1>
}
```

### 类式组件

```jsx
class MyComponent extends Component {
  reander() {
    return <h1>foo</h1>
  }
}
```

## 事件

### 使用 `bind`

```jsx
constructor() {
  this.handleClick = this.handleClick.bind(this)
}
handleClick() {}
<MyComponent onClick={this.handleClick}></MyComponent>
```

### 使用 `lambda`

```jsx
handleClick = () => {}
```

## 三大属性

### state

```jsx
// 初始化
state = { key: value }
// 更新
this.setState({ key: value })
```

### props

```jsx
class MyComponent extends React.Component {
  render() {
    return <div>{this.props.foo}</div>
  }
}

<MyComponent foo="bar" {...obj}/>
```

#### 默认

```jsx
// 类外
MyComponent.defaultProps = {
  name: 'Runoob'
};

// 类内
static defaultProps = {}
```

#### 校验

```jsx
// 依赖
<script src="https://cdn.bootcss.com/prop-types/15.6.1/prop-types.js"></script>
npm i prop-types
import PropTypes from 'prop-types';

// 类外
MyComponent.propTypes = {
  name: PropTypes.string.isRequired
};
// 类内
static propTypes = {}
```

### refs

#### 属性形式

```jsx
<input ref="input"/>
this.refs.input
```

#### 回调形式

```jsx
<input ref={input => this.input = input}/>
this.input
```

#### `createRef`

```jsx
foo = React.createRef()
<input type="text" ref={this.foo} />
this.foo.current
```

## 生命周期

- https://zhuanlan.zhihu.com/p/38030418

## 脚手架

```bash
npm i -g create-react-app
create-react-app foo
```

> gyp 错误：
>
> - 使用 npm 自带的镜像
>
> - https://github.com/nodejs/node-gyp#on-windows
>
> ```shell
> # 没用
> npm install -g windows-build-tools
> ```

## 配置代理

### 方式一

`package.json`

```json
"proxy":"http://localhost:5000"
```

3000 不存在时会转发

### 方式二

`src/setupProxy.js`

```js
const proxy = require('http-proxy-middleware') // 引入即可，不需要安装 

module.exports = function(app) {  
  app.use(    
      proxy('/api1', {  //api1是需要转发的请求(所有带有/api1前缀的请求都会转发给5000)    
         target: 'http://localhost:5000', //配置转发目标地址(能返回数据的服务器地址)  
         changeOrigin: true, //控制服务器接收到的请求头中host字段的值  
         /*  
            changeOrigin设置为true时，服务器收到的请求头中的host为：localhost:5000  
            changeOrigin设置为false时，服务器收到的请求头中的host为：localhost:3000  
            changeOrigin默认值为false，但我们一般将changeOrigin值设为true  
         */  
         pathRewrite: {'^/api1': ''} //去除请求前缀，保证交给后台服务器的是正常请求地址(必须配置)  
      }),  
      proxy('/api2', {   
         target: 'http://localhost:5001',  
         changeOrigin: true,  
         pathRewrite: {'^/api2': ''}  
      })  
  )  
}
```

## 消息传递

- https://github.com/mroderick/PubSubJS

## 路由

