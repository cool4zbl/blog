---
title: 从十个 React 迷你设计模式谈开去
tags: notes, frontend

---

很早之前就一直在读的一篇文章，[10 个React Mini 设计模式](https://hackernoon.com/10-react-mini-patterns-c1da92f068c5)，
一边做 `Creator` 项目，也一边终于把它精读完。
结合自己的开发时候的项目经验，做了点笔记。
`Creator` 项目是一个多端（Web + Mobile）React SPA，且有一些表单填写和复杂的交互组件，自己单独封装了一个很简单的基于事件的 `Store`，开发过程中收获很大，这些细节之后可以细说。

原文作者说你是不是天天写 React, 写着写着发现自己可能经常用来实现需求的，也总是那么几个方法，往大了讲其实就是开发中的 **设计模式**。但是这里我们称为 **Mini Patterns**。

## #1 Sending data down and up

![Data-flow](https://cdn-images-1.medium.com/max/2000/1*J5XOQh2WKIl0NFTAMvcVbQ.png)

- React 数据流
- ParentComponent  通过 `props` 传给 ChildComponent 值
- ChildComponent 通过 `props` 传过来的一些 function 回调 parent 的一些方法。



## #2 Fixing HTML’s inputs

> If I’m building a site that will have a lot of user inputs, one of the first things I do is fix this.
>
> You don’t need to keep working with the somewhat ass-about nature of HTML’s user input elements.

![User Inputs](https://cdn-images-1.medium.com/max/800/1*WTUJjlFOOnetc5NpbykN0w.png)

- 如果需要有大量 user inputs，最好是自己实现一套相关组件。

- 所以在 Creator 中基本自己实现了 `input`，`Select` 等组件。需求简单所以实现得也是很简单。所以其实 `Select` 组件仍然需要优化，比如自定义 `option` 样式，多选等等。

- Inputs should return a value via an `onChange` method, not a JavaScript `Event` instance, shouldn’t they?

- Input 最好通过 `onChange` 返回一个值，而不是通过一个 JS `Event` 实例。

- You can go a step further and ensure that the data type returned in `onChange` matches the type passed in. If the `typeof props.value` is `number`, then convert `e.target.value` back to a number before sending the data out again.

- 在返回 `onChange` 的值之前确保一下是不是和输入的类型匹配。比如 `typeof props.value === 'number'` 的话，在返回 `e.target.value` 前需要确保也是数字类型。

- 这里项目中有个选择证件类型的 `Select`，与后端默认 身份证 = 0 / 护照 = 1，但是在 `e.target.value` 时候忘记 convert 了。所以还是需要记得判断下 `option` 的值类型。

  ```javascript
  let {name, value} = e.target
  value = isNaN(Number(value)) ? value : Number(value)
  ```

  ​

- A set of radio buttons is functionally the same thing as a `<select>`, right? It’s messed up to treat them in a completely different manner when the only difference is the UI. Maybe for your app it makes sense to have a single `<PickOneFromMany />` component and pass either `ui="radio"` or `ui="dropDown"`.

- 一堆单选按钮在功能上和一个 `<select>` 组件是一样的。没有必要把它们完全不一样地来对待，因为它们仅仅是 UI 不一样。其实可能只需要一个 `<PickOneFromMany />` 组件就好，通过 `ui="radio"` 或者`ui="dropdown"` 来区分。

- **React Form 与 HTML 的不同**

- `value/checked` 设置后用户输入无效，相当于设置了 value -> controlled component.

- `textarea` 的值要设置在 value 属性

- `select` 的`value` 属性可以是数组，不建议使用 `option` 的 `selected` 属性

- `input/textarea` 的 `onChange` 每次输入都会触发，即使不失去焦点

- `radio/checkbox`  点击后触发 `onChange



## #3 Binding labels to inputs with unique IDs

> if you care about your users, you’ll bind your `<label>` elements to your `<input>`s via an `id`/`for` combo.
>
> You *could* generate a random ID for each input/label pair, but then your client-rendered HTML won’t match your server-rendered HTML. Checksum error! That’s no good.
>
> So, instead you can create a little module that gives an incrementing ID, and use that in an `Input` component like so:

```jsx
// Input Component
class Input extends React.Component {
  constructor(props) {
    super(props);
    this.id = getNextId();

    this.onChange = this.onChange.bind(this);
  }

  onChange(e) {
    this.props.onChange(e.target.value);
  }

  render() {
    return (
      <label htmlFor={this.id}>
        {this.props.label}

        <input
          id={this.id}
          value={this.props.value}
          onChange={this.onChange}
          />
      </label>
    );
  }
}

// elementIdCreator.js
let count = 1;

export const resetId = () => {
  count = 1;
}

export const getNextId = () => {
  return `element-id-${count++}`;
}
```

- 这里大概是自动给 `label`/`input` 加上一对一的 id.
- Creator 中好像没有这样使用。



## #4 Controlling CSS with props

Three distinct ways to control the CSS applied to a component.

1. Using themes. (Used in Proj Creator)

   `<Button theme="secondary">Hello</Button>`

   Tip: Do your best to only require one theme per component.

   这种可能适合页面主题定制化。

   Creator 中的 `<Button />` 本来是用 theme 做区分，但是好像设计那边看起来就是一个主题，豆瓣绿经典款，所以后来改为了使用下面两种方式。

   ​

2. Using flags. (Used too.)

   `<Button theme="secondary" rounded>Hello</Button>`

   Creator Project:

   ```jsx
   Button.propTypes = {
     size: PropTypes.oneOf([
       'sm',
       'md',
       'lg',
       'row'
     ]),
     status: PropTypes.oneOf(Object.values(BUTTON_STATUS)),
     type: PropTypes.oneOf([
       'submit',
       'save',
       'cancel'
       ])
   }


   // use className to control styles

     const cls = classNames('btn', {
       [`${prefixCls}-btn`]: true,
       [`${prefixCls}-btn-${size}`]: !!size,
       [`${prefixCls}-btn-${status}`]: !!status,
       [`${prefixCls}-btn-${type}`]: !!type
     }, props.className)

   ```

   ​

3. Setting values.

   Pass the value of a CSS property directly. (set it as an inline style)

   `<Icon width="25" height="25" type="search" />`

   ### An example

   ![creating-a-link-component](https://cdn-images-1.medium.com/max/800/1*Kx1jOQONhFZPnGe72Fd4tQ.png)

   ```jsx
   // Link.js
   const Link = (props) => {
     let className = `link link--${props.theme}-theme`;

     if (!props.underline) className += ' link--no-underline';

     return <a href={props.href} className={className}>{props.children}</a>;
   };

   Link.propTypes = {
     theme: PropTypes.oneOf([
       'default', // primary color, no underline
       'blend', // inherit surrounding styles
       'primary-button', // primary color, solid block
     ]),
     underline: PropTypes.bool,
     href: PropTypes.string.isRequired,
     children: PropTypes.oneOfType([
       PropTypes.element,
       PropTypes.array,
       PropTypes.string,
     ]).isRequired,
   };

   Link.defaultProps = {
     theme: 'default',
     underline: false,
   };

   ```

   ```scss
   // Link.css
   .link--default-theme,
   .link--blend-theme:hover {
     color: #D84315;
   }

   .link--blend-theme {
     color: inherit;
   }

   .link--default-theme:hover,
   .link--blend-theme:hover {
     text-decoration: underline;
   }

   .link--primary-button-theme {
     display: inline-block;
     padding: 12px 25px;
     font-size: 18px;
     background: #D84315;
     color: white;
   }

   .link--no-underline {
     text-decoration: none;
   }
   ```

   ​

   > JavaScript is easy, but with CSS you pay for your sins — once you’ve started a mess, it’s not easy to back out of.
   >
   > True fact: fighting CSS specificity is the number one cause of death among web developers.

   嗯，这里原文作者用 CSS specificity 优先级举了个例子。比如他说你现在可以去看看 medium 顶端导航上大 Title 的CSS 样式，

   > just guess how many CSS rules are combined to make this round circle with a number in it?
   >
   > Twenty three rules.
   >
   > That’s *not *including the styles inherited from eleven other rules.
   >
   > The line-height alone is overridden nine times.

   光是 `line-height` 特么的就重写了九次！！！

   ![line-height-css-rules](https://cdn-images-1.medium.com/max/800/1*lQzlIf8PPqeLUS5VOvTH4Q.png)

   ​

   这 line-height 要是一只猫的话，现在也早死了吧。

   React 的话，就好办了。

   - 控制组件的 classes ；
   - 移掉所有的全局 resets 然后都把它们扔到 Button.scss 中；
   - 可以用 `all: unset` 去掉所有浏览器初始样式。



## #5 The switching component

The switching component, rendering one of many components.

> This may be a `<Page>` component that displays one of many pages. Or tabs in a tab set, or different modals in a modal component.

```javascript
import HomePage from './HomePage.jsx';
import AboutPage from './AboutPage.jsx';
import UserPage from './UserPage.jsx';
import FourOhFourPage from './FourOhFourPage.jsx';

const PAGES = {
  home: HomePage,
  about: AboutPage,
  user: UserPage,
};

const Page = (props) => {
  const Handler = PAGES[props.page] || FourOhFourPage;

  return <Handler {...props} />
};

Page.propTypes = {
    page: PropTypes.oneOf(Object.keys(PAGES)).isRequired,
};

// Usage

<Page page="home" />

```

If you replace the keys `home`, `about` and `user` with `/`, `/about`, and `/user`, you’ve got yourself half a router.

(Future post idea: removing `react-router`.)

这里 Creator 中还是使用了 `react-router` 作为 SPA 路由。

```javascript
// Route.jsx
import React from 'react'
import IntroPage from '../Page/IntroPage'
import ApplyFormPage from '../Page/ApplyFormPage'
import AddWorksPage from '../Page/AddWorksPage'
import ApplyDonePage from '../Page/ApplyDonePage'
import MyWorksPage from '../Page/MyWorksPage'

const defaultHeader = () => <h1>创作者认证申请</h1>
const routes = [
  { path: '/',
    exact: true,
    header: defaultHeader,
    main: () => (<IntroPage />)
  },
  { path: '/apply/intro',
    header: defaultHeader,
    main: () => (<IntroPage />)
  },
  { path: '/apply/step1',
    header: defaultHeader,
    main: () => (<ApplyFormPage />)
  },
  { path: '/apply/step2',
    header: defaultHeader,
    main: () => (<AddWorksPage />)
  },
  { path: '/apply/step3',
    header: defaultHeader,
    main: () => (<ApplyDonePage />)
  },
  { path: '/myworks',
    header: () => <h1>管理我的作品</h1>,
    main: () => (<MyWorksPage />)
  }
]
export default routes
```

```javascript
// App.js
import {
  HashRouter,
  Route
} from 'react-router-dom'
import routes from './Route'

const App = () => (
  <HashRouter>
    <div className='App'>
      <div id='creator-wrapper'>
        <div className='header'>
          { routes.map((route, index) => (
            <Route key={index} path={route.path}
              exact={route.exact}
              component={route.header}
            />
          )) }
        </div>
        <div className='main'>
          { routes.map((route, index) => (
            <Route key={index} path={route.path}
              exact={route.exact}
              component={route.main} />
          )) }
        </div>
        { isMobile ? Footer() : Sidebar() }
      </div>
    </div>
  </HashRouter>
)

```



## #6 Reaching into a component

### render

React Virtual DOM ==> render= => DOM

```javascript
ReactComponent render(
  ReactElement element,
  DOMElement container,
  [function callback]
)
```

> Render a ReactElement into the DOM in the supplied `container` and return a [reference](more-about-refs.html) to the component (or returns `null` for [stateless components](reusable-components.html#stateless-functions)).

> `ReactDOM.render()` controls the contents of the container node you pass in. Any existing DOM elements inside are replaced when first called. Later calls use React’s DOM diffing algorithm for efficient updates.

- `ReactElement` into DOM.
- 有状态组件 => `refs`，无状态组件 => `null`
- 组件初次渲染之后再次更新，会使用 ReactDOM diffing algorithm
- 装载完后，执行回调 callback
- `ReactDOM.render()` 不会影响 container node，只会影响 container node 的 children nodes. （可能是被覆盖替换啊..）



```javascript
const myApp = <App />   // just a ReactElement.(a object)

const myAppInstance = ReactDOM.render(<App />, document.getElementById('root'))
myAppInstance.doSth() // The ref returned from ReactDOM.render
```

这里利用 `render` 方法得到了 App 组件的实例，就可以使用它做点什么了。

但是如果在组件内，JSX 并不会返回一个组件的实例。组件内只是一个 ReactElement，告诉 React 加载的组件应该长什么样。

> Keep in mind, however, that the JSX doesn't return a component instance! It's just a **ReactElement**: a lightweight representation that tells React what the mounted component should look like.

### ref

一个神奇的属性。

#### The ref Callback Attribute

- 可以给任意 React 组件加上 `ref` prop. 组件被调用时候会新建一个该组件实例，而 `ref` 会指向这个实例。


- 可以是一个 callback function，会在组件加载后立即执行。

  ```javascript
  // ES5

  render: function() {
    return (
      <TextInput
        ref={function(input) {
          if (input != null) {
            input.focus();
          }
        }} />
    );
  },

  // or ES6 arrow function way:
  render() {
    return <TextInput ref={ c => this._input = c } />
  }
  componentDidMount() {
    this._input.focuse()
  }
  ```

  ​

>  When attaching a ref to a DOM component like `<div />`, you get the DOM node back; when attaching a ref to a composite component like `<TextInput />`, you'll get the React class instance.

- `refs` in `ReactComponent` => 得到 ReactComponent 实例，就可以调用相关实例方法了（继续 findDOMNode(refs) 就可以得到 DOM 节点，使用 DOM 方法）。
- `refs` in `DOM`  => 得到 DOM 节点，就可以使用 DOM 方法。
- *Note:* Note that when the referenced component is unmounted and whenever the ref changes, the old ref will be called with `null` as an argument. This prevents memory leaks in the case that the instance is stored, as in the first example. Also note that when writing refs with inline function expressions as in the examples here, React sees a different function object each time so on every update, ref will be called with `null` immediately before it's called with the component instance.
- 为防止内存泄露，当引用组件被卸载或者 `ref` 改变的时候，`ref = null`.
- 如果用 inline function，因为每次都是一个不同的 function object，所以当组件每次更新的时候，`ref` 都会被设置为 `null` 直到组件实例再次调用它。



#### The ref String Attribute *legacy

要获取一个 React 组件的引用，既可以使用 this 来获取当前 ReactComponent，也可以使用 `ref` 来获取子组件的引用。

```javascript
<input ref="myInput" />

// used in componentDidMount()
var input = this.refs.myInput;
var inputValue = input.value;
var inputRect = input.getBoundingClientRect();
```

#### refs 使用

- DOM 操作

> Performing DOM measurements almost always requires reaching out to a "native" component such as `<input />` and accessing its underlying DOM node using a ref. Refs are one of the only practical ways of doing this reliably.

- 对于 `stateless component`， `findDOMNode()` & `ref` 返回的都是 `null`，因为它只是函数执行，并不返回一个实例 `a backing instance`。要用的话只能自己去手动包一层 component.



#### An example

Like adding `autofucus` to the input to pease your users in an easy way.



The React Way

```javascript
// Child Component
class Input extends Compnent {
  focus() {
    this.input.focus()
  }
  render() {
    return (
      <input ref={(el)=> this.input = el} />
    )
  }
}

// Parent Component
class SignInModal extends Component {
  componentDidMount() {
    this.InputComponent.focus(); // 拿到 Input 组件的引用，就可以调用 Input 组件方法
  }

  render() {
    return (
      <div>
        <label>User name: </label>
        <Input
          ref={comp => { this.InputComponent = comp; }}
        />
      </div>
    )
  }
}

```



## #7 Almost-components

> Don’t prematurely componentize. Components aren’t like teaspoons; you *can *have too many.
>
> What I am saying: “take something that you *don’t* think should be a component, and make it a bit more like its own component (if it can be).”

让那些你认为不应该成为一个组件的东西，长得更像组件一点（如果它可以的话）。



## #8 Components for formatting text

用来格式化的组件，也就是组件也可以工具化。

```javascript
// Here’s a <Price> component that takes a number and returns a pretty string, with or without decimals and a ‘$’ sign.

const Price = (props) => {
    const price = props.children.toLocaleString('en', {
      style: props.showSymbol ? 'currency' : undefined,
      currency: props.showSymbol ? 'USD' : undefined,
      maximumFractionDigits: props.showDecimals ? 2 : 0,
    });

    return <span className={props.className}>{price}</span>
};

Price.propTypes = {
  className: React.PropTypes.string,
  children: React.PropTypes.number,
  showDecimals: React.PropTypes.bool,
  showSymbol: React.PropTypes.bool,
};

Price.defaultProps = {
  children: 0,
  showDecimals: true,
  showSymbol: true,
};

const Page = () => {
  const lambPrice = 1234.567;
  const jetPrice = 999999.99;
  const bootPrice = 34.567;

  return (
    <div>
      <p>One lamb is <Price className="expensive">{lambPrice}</Price></p>
      <p>One jet is <Price showDecimals={false}>{jetPrice}</Price></p>
      <p>Those gumboots will set ya back <Price showDecimals={false} showSymbol={false}>{bootPrice}</Price> bucks.</p>
    </div>
  );
};
```

这里当然可以很简单的用 less code function 来实现

```javascript
// could just easily use a function
function numberToPrice(num, options = {}) {
    const showSymbol = options.showSymbol !== false;
    const showDecimals = options.showDecimals !== false;

    return num.toLocaleString('en', {
      style: showSymbol ? 'currency' : undefined,
      currency: showSymbol ? 'USD' : undefined,
      maximumFractionDigits: showDecimals ? 2 : 0,
    });
}

const Page = () => {
  const lambPrice = 1234.567;
  const jetPrice = 999999.99;
  const bootPrice = 34.567;

  return (
    <div>
      <p>One lamb is <span className="expensive">{numberToPrice(lambPrice)}</span></p>
      <p>One jet is {numberToPrice(jetPrice, { showDecimals: false })}</p>
      <p>Those gumboots will set ya back {numberToPrice(bootPrice, { showDecimals: false, showSymbol: false })} bucks.</p>
    </div>
  );

```



## #9 The store is the component’s servant

用 `store` 来管理组件复杂度。

My suggestion:

1. Work out the general structure of your components and the data they will require
2. Design your store to support those requirements
3. Do whatever you need to do to your incoming data to make it fit into the store.

推荐使用单个模块来管理所有 Incoming data，所有的数据处理放在一起做，单元测试什么的也变简单了。

```javascript
// react/redux way

fetch(`/api/search?${queryParams}`)
.then(response => response.json())
.then(normalizeSearchResultsApiData) // the do-it-all data massager
.then(normalData => {
    // dispatch normalData to the store here
});
```

**这里推荐徐飞在 QCon 上分享的 [单页引用的数据流方案探索](https://zhuanlan.zhihu.com/p/26426054)**




## #10 Importing components without relative paths

Turn

```javascript
import Button from '../../../../Button/Button.jsx';
import Icon from '../../../../Icon/Icon.jsx';
import Footer from '../../Footer/Footer.jsx';
```

Into

```javascript
import {Button, Icon, Footer} from 'Components';
```



更灵活方便使用组件。

使用 `Webpack2` 可以直接配置

```javascript
// exports all components wherever they are
// Ref: Webpack require.context
// https://webpack.github.io/docs/context.html

// ./{xxx}/yyy/index.js => import { yyy } from 'components'
const req = require.context('.', true, /\.\/[^/]+\/[^/]+\/index\.js$/)

req.keys().forEach((key) => {
  const componentName = key.replace(/^.+\/([^/]+)\/index\.js/, '$1')
  module.exports[componentName] = req(key).default
})
```

Creator 中因为用的 `create-react-app` CLI，无法自己配置 Webpack，所以并没有用到...
