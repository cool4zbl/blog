---
title: Uber 高性能 Web App 优化实践
tags: tech, frontend, optimization
time: 10 July 2017 at 11:55 AM
---



原文 [Building m.uber: ENGINEERING A HIGH-PERFORMANCE WEB APP FOR THE GLOBAL MARKET](https://eng.uber.com/m-uber/)

**Performance matters on mobile.**

又是一篇关于性能优化的实践。

m.uber 团队对 m.uber，他们的超级轻量 web app 做了一些性能优化的工作。

范围全面，从代码到打包到部署到缓存，都有涉及。

## TL;DR

### Performance Tools

- Preact over React
- Webpack  [dynamic bundle splitting](https://webpack.js.org/guides/code-splitting-async/) & [tree-shaking capabilities ](https://webpack.js.org/guides/tree-shaking/) 
- Tiny Libraries & Minimal Dependencies
- [source-map-explorer](https://www.npmjs.com/package/source-map-explorer) 




下面是正文：



### Smaller, faster: how we built it

#### 技术栈

代码层面：ES2015+，使用 Babel 编译；

框架：`Preact` + `Webpack`；

设计的痛点是，在保证类 Native App 丰富体验的同时，最小化客户端体积。所以 Preact + [Webpack](https://webpack.github.io/) 的 [dynamic bundle splitting](https://webpack.js.org/guides/code-splitting-async/) 和 [tree-shaking capabilities ](https://webpack.js.org/guides/tree-shaking/) 功能完美搭配。



#### Initial server render 首次服务端渲染

因为在所有核心打包的 JS 全部被下载前，客户端或浏览器都不能开始渲染 markup 标记。

为了更快首屏渲染，m.uber 在首次浏览器请求时候会返回服务端渲染好的 Preact，且 `state` 及 `markup` 都嵌到行内，全部都是字符串，所以这些内容一旦被客户端下载，就可以立马加载出来。

#### Serve bundles on demand 按需打包加载

m.uber 中大部分 JS 都是用来做一些辅助功能，这些都是没有必要一次性加载的，所以他们用了 Webpack 的 `Code Splitting` 工具按需加载代码。

（这个我在 Accounts 项目也实践过，一个巨大的 JS 文件拆分成了三个小的 JS 文件，不过也需要考虑每个 HTTP 请求时间。）

> We use a *splitPage* function that returns the ancillary bundle wrapped in an asynchronous component.

```javascript
// Example: settings page
const AsyncSettings = splitPage(
 {load: () => import(‘../../screens/settings’)}
);

// 当且仅当 `AsyncSettings` 被 Parent Component render() 调用，
// setting bundle js 才会被下载.
```

#### Tiny Libraries 更小的库

m.uber 本意上是希望在 2G 网下也能飞快，所以打包后的体积也很重要。

他们 App 核心部分（叫车功能）在 gzipped & minified 后只有 50kB 大小，所以在典型 2G 网（50kB/s, 500ms 延时）下，也能三秒内开始交互。

以下是优化前后的打包和依赖的对比。

![bundle size](https://eng.uber.com/wp-content/uploads/2017/06/image4-3.png)

​

#### Preact over React

体积原因， Preact (3kB GZip/minified)  < React (45kB).

Preact 除了不支持 `PropTypes` 和合成事件外，还是可以的。

Preact 据说在组件和元素回收可能有点点问题，不过他们还是正在解决的吧... 反正 uber 的人觉得他们用着还不错。

#### Minimal Dependencies 最小化依赖

为了对付依赖膨胀（dependency bloat），Uber 的人对安装的 npm 包特别挑剔。

他们推荐使用 `Just` 那个包，或者参考它的 npm package 思想：一个函数只做一件事且无其他任何依赖。（去 Just GitHub 看，包作者就是写这篇文章的人...）

与服务器端进行数据传输代价高昂，所以一些特别大的库，比如 `Moment` 这种超大的库就是不需要被下载的（但是我在想的是，他们是自己实现了一套类似 Moment 的东西吗？）

推荐了 [source-map-explorer](https://www.npmjs.com/package/source-map-explorer)  工具来分析加载的依赖。

于是我用这个工具来分析了下 `creator-main-js`。

![creator-js-source-map-explorer](/content/images/m_uber/creator-js-source-map-explorer.png)



#### Conditional Feature Set

首次加载会调用 `window.performance` API，然后基于结果来考虑在该设备上是加载还是隐藏交互地图。

相当于是渐进增强的思想吧。

#### Minimal render Calls

Preact 每次 `render` VDOM 都是有代价的。

尽可能地多用 `shouldComponentUpdate` 最小化 `render` 的调用。

#### Caching

##### Service Workers

又见 service workers，截获 URL 请求，修改网络和本地磁盘资源获取变为配置好的获取逻辑。

Uber 把首次 HTML 响应和 JS 包都用 SW 缓存了，所以就算间歇性断网 m.uber 也还是能渲染内容。

SW 也极大程度上降低了加载时间。 磁盘 I/O 性能在不同的 OS 和设备上都很不一样，就算从磁盘缓存拿数据也是[特别慢](https://github.com/w3c/ServiceWorker/blob/master/implementation_considerations.md#racing-allowed)。SW 支持从浏览器缓存加载所有内容。

m.uber 客户端在每次 build 后都会安装一个新的 SW。

Webpack 每次都会生成动态打包名，build 环节会把新的打包名直接写到 service worker 模块里面。

一旦安装，会首先缓存核心 JS 库，然后 lazy-loading 缓存 HTML 及一些辅助的按需加载的 JS 包。

##### Local Storage

Uber 的人觉得每次把经常变化的响应数据缓存到 SW 不太好，他们就把这些都扔到了浏览器 `localStorage`.

m.uber 每隔几秒就会从服务器端拉 ride status，再把这些最新的 status data 都放在 `localStorage` 中，当乘客返回 app 时候，就能立马重新渲染页面，而不需要等待 API 链路耗时。

每次的 status data 很小且体积有限，所以存储的更新很快快，可依赖性也好。

他们最后终于意识到，其实并不需要类似 `indexedDB` 这样的本地异步存储 API。

#### Styling

##### Styletron

样式都是用的 css-in-js，写成了 JS 对象形式，放在每个组件中。

使用了 [Styletron](https://github.com/rtsao/styletron) 动态生成样式。可以像 JS 一样，动态打包切割、异步加载样式。

Styletron 可以通过创建原子样式(atomic stylesheet)，减少重复的样式声明，性能好像也不错， [best-in-class rendering performance](https://github.com/necolas/react-native-web/tree/master/benchmarks). 。

这个倒是可以考虑弄下，`create-react-app` 貌似不支持 `css-in-modules` 这种方式。Rocket 参考 `arc` 的 **Atomic** 思想，使用了 `styled-component`，不过看上面那个对比，性能好像有点低。

##### SVGs
> Used [SVGO](https://github.com/svg/svgo) together with manual optimizations to further shorten the paths
> Replace polylines with basic shapes.
> View box dimensions with suitable divisors to avoid expensive decimals in paths.

为了节省空间，对于图标形式的图片尽量用 SVG 格式，然后在 `render` 方法中引入它们。

使用 SVGO、多使用简单图形、view box 使用合适的维度避免昂贵的数学计算开销。

整个 App 体积下降明显！

##### Fonts

谨慎使用字体大小和颜色，其实可以完全减少自定义字体，不用向视觉设计妥协了。

#### Error Handling

- 没有使用很大的错误监控的库，而是拓展了 `window.onerror` ，向服务器端发送客户端错误信息。
- 给 Preact `render` & `shouldComponentUpdate` 包了一层，检测生命周期方法错误。
- 因为这样的设计，所以 CDN-hosted file 抛出来的错误并不会给 `window.onerror` 提供什么有效信息，除非正确设置 CORS 头部。但就算是设置了 CORS，异步事件发生的错误还是并不能被跟踪到。于是他们把所有的事件监听都包了一层，允许错误通过 `try/catch` 传到父模块。

### Next Steps

感觉 Uber 对于 UX 真的是做了大量的工夫，但是他们并没有因此而停止步伐。

- 正打算确定一个方案：组件仅仅接受扁平化的基本数据类型和数组类型集合属性，最小化 `render`调用。这样的话就可以用 `React.pureComponent` （这里自动包含了 `SCU`）。`render`方法也可以专注于生成 HTML markup，而不需要处理一大堆逻辑和其他没什么意义的任务。把 API 响应转换为扁平的能被服务端逻辑代理的基本数据结构 (see [normalizr](https://github.com/paularmstrong/normalizr)) ，或者用 `mapStateToProps`。~~神奇的是，Creator 项目的 `WorkStore` 也用了类似 normalizr 的数据结构存储~~（后来为了方便维护还是改用了 Redux...）。
- 把 `actions` & `reducers` 结合起来，更容易分开打包。
- 对所有请求使用  [HTTP/2](https://en.wikipedia.org/wiki/HTTP/2)  ，用 push notifications 代替 polling APIs.
- 另外，Uber 人正在考虑把 m.uber 的架构抽象出一个开源架构，成为未来轻量级 Uber Web App的基础。这让我想起了之前看过的[滴滴 Web App 架构](https://github.com/DDFE/DDFE-blog/issues/4)，同样是打车软件，滴滴 FE team 在 Web App 架构上也是做了大量工夫，值得参考学习。


纵观这些方案，可以说把 **[PRPL Patterns](https://developers.google.com/web/fundamentals/performance/prpl-pattern/)** 做到了极致。



以上。







