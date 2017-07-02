---
title: [译]前端指南
published_at: 14 Mar 15 @ 23:51
tags: translate, frontend
---


**Update**
以下大概写于两年前，亟待更新。

---
几天前从Github上看到了这篇[前端编码最佳实践](https://github.com/bendc/frontend-guidelines)，Star数已破4K，觉得应该是篇不错的小指南，花了点时间将它稍作翻译，也当是复习复习 `HTML&CSS&JS`。
翻译时随手参照了《CSS设计指南》、《精通CSS-2ndEdition》、老道的《JavaScript语言精粹》、NZ大神的《JavaScript高级程序设计》，在学习了一些专有名词表达同时，也学到了许多有用的代码和思想。
不过原作者好像是`CoffeeScript`爱好者，且广泛使用了`ES6`特性，所以有些名词和表达我暂未理解透彻，还需斟酌。故现将原文译文参照排版，还待之后的更新。

---
HTML
---
###语义化（Semantics）
HTML5 provides us with lots of semantic elements aimed to describe precisely the content. Make sure you benefit from its rich vocabulary.
HTML5 给我们提供了大量的语义化元素标签去准确的描述元素内容。确保你从它的丰富的词汇中获益。

	<!-- bad -->
	<div id="main">
  		<div class="article">
    			<div class="header">
			      <h1>Blog post</h1>
			      <p>Published: <span>21st Feb, 2015</span></p>
    			</div>
    			<p>…</p>
  		</div>
	</div>
	<!-- good -->
	<main>
  		<article>
    			<header>
			      <h1>Blog post</h1>
      				<p>Published: <time datetime="2015-02-21">21st Feb, 2015</time></p>
 			</header>
    			<p>…</p>
 		 </article>
	</main>

Make sure you understand the semantic of the elements you're using. It's worse to use a semantic element in a wrong way than staying neutral.
确保你理解你正在使用的元素的语义。错误的使用一个语义化标签元素比保持中立更糟糕。

	<!-- bad -->
	<h1>
  		<figure>
    			<img alt=Company src=logo.png>
  		</figure>
	</h1>

	<!-- good -->
	<h1>
  		<img alt=Company src=logo.png>
	</h1>

简洁（Brevity）
Keep your code terse. Forget about your old XHTML habits.
保持你代码的简洁精练。把你的老掉牙XHTML习惯忘掉吧。

    <!-- bad -->
    <!doctype html>
    <html lang=en>
      <head>
        <meta http-equiv=Content-Type content="text/html; charset=utf-8" />
        <title>Contact</title>
        <link rel=stylesheet href=style.css type=text/css />
      </head>
      <body>
        <h1>Contact me</h1>
        <label>
          Email address:
          <input type=email placeholder=you@email.com required=required />
        </label>
        <script src=main.js type=text/javascript></script>
      </body>
    </html>

    <!-- good -->
    <!doctype html>
    <html lang=en>
      <meta charset=utf-8>
      <title>Contact</title>
      <link rel=stylesheet href=style.css>

      <h1>Contact me</h1>
      <label>
        Email address:
        <input type=email placeholder=you@email.com required>
      </label>
      <script src=main.js></script>
    </html>

 容易理解（Accessibility）
 Accessibility shouldn't be an afterthought. You don't have to be a WCAG expert to improve your website, you can start immediately by fixing the little things that make a huge difference, such as:
容易理解不应该是一个附加品。你没必要成为一名WCAG专家再来改善你的网站，你马上就能通过修复一些小事情来make a huge difference。

- learning to use the alt attribute properly
- 学会正确使用`alt`属性
- making sure your links and buttons are marked as such (no <div class=button> atrocities)
- 确保你的链接和按钮都这样被标记（不要`<div class=button>`残暴）
- not relying exclusively on colors to communicate information
- 交流信息时不仅仅依赖颜色
- explicitly labelling form controls
- 明确地标签表单控制

		<!-- bad -->
		<h1><img alt="Logo" src="logo.png"></h1>

		<!-- good -->
		<h1><img alt="My Company, Inc." src="logo.png"></h1>

语言（Language）
While defining the language and character encoding is optional, it's recommended to always declare both at document level, even if they're specified in your HTTP headers. Favor UTF-8 over any other character encoding.
当界定的编码语言和字符是可选择的话，建议你永远都在文档级别（document level）申明，即使它们已在你的HTTP头部规定好。喜欢`UTF-8`胜过其他类型字符编码一万倍~

	<!-- bad -->
	<!doctype html>
	<title>Hello, world.</title>

	<!-- good -->
	<!doctype html>
	<html lang=en>
  		<meta charset=utf-8>
  		<title>Hello, world.</title>
	</html>

性能（Performance）
Unless there's a valid reason for loading your scripts before your content, don't block the rendering of your page. If your style sheet is heavy, isolate the styles that are absolutely required initially and defer the loading of the secondary declarations in a separate style sheet. Two HTTP requests is significantly slower than one, but the perception of speed is the most important factor.
除非在内容加载之前先载入脚本有个合理的理由，那么就别阻塞你页面的渲染。
如果CSS文件很大，就页面初始时必要的样式分离出来，然后再延迟加载独立样式表中的次要声明。两次HTTP请求会显著地慢于一次，但是（用户对页面加载）速度的感觉才是最重要的因素。

    <!-- bad -->
    <!doctype html>
    <meta charset=utf-8>
    <script src=analytics.js></script>
    <title>Hello, world.</title>
    <p>...</p>

    <!-- good -->
    <!doctype html>
    <meta charset=utf-8>
    <title>Hello, world.</title>
    <p>...</p>
    <script src=analytics.js></script>

CSS
---
 分号（Semicolons）
While the semicolon is technically a separator in CSS, always treat it as a terminator.
虽然从技术上说，分号在CSS中是一个分离器，但永远把它当一个终止器来看待。

	/* bad */
	div {
  		color: red
	}

	/* good */
	div {
  		color: red;
	}

盒模型（Box Model）
The box model should ideally be the same for the entire document. A global * { box-sizing: border-box; } is fine, but don't change the default box model on specific elements if you can avoid it.
理想状况下，整个文档的盒模型应该保持一样。 全局的 `* { box-sizing: border-box; }` 是很好，但尽量别去改变特定元素的默认盒模型。

	/* bad */
    div {
      width: 100%;
      padding: 10px;
      box-sizing: border-box;
    }

    /* good */
    div {
      padding: 10px;
    }

  流（Flow）
Don't change the default behavior of an element if you can avoid it. Keep elements in the natural document flow as much as you can. For example, removing the white-space below an image shouldn't make you change its default display:
尽量不要去改变一个元素的默认行为。尽你所能让标签元素都待在正常文档流里。比如说，移除一张图片下方空白不应改变它的默认显示：

    /* bad */
    img {
      display: block;
    }

    /* good */
    img {
      vertical-align: middle;
    }

 Similarly, don't take an element off the flow if you can avoid it.
 同样地，尽量别把一个元素从文档流中拿出来。

 	 /* bad */
 	 div {
 	 	width: 100px;
 	 	position: absolute;
 	 	right: 0;
 	 }

 	  /* good */
 	  div {
 	  	width: 100px;
 	  	margin-left: auto;
 	  }

定位（Positioning）
There are many ways to position elements in CSS but try to restrict yourself to the properties/values below. By order of preference:
在CSS中有许多方法来定位元素，但尽量限制自己来使用以下的属性/值。通过偏好排序：

	display: block;
	display: flex;
	position: relative;
	position: sticky;
	position: absolute;
	position: fixed;

选择符（Selectors）
Minimize selectors tightly coupled to the DOM. Consider adding a class to the elements you want to match when your selector exceeds 3 structural pseudo-classes, descendant or sibling combinators.
最小化和DOM紧密耦合的选择符。当选择符超出三个结构伪类（structural pseudo-classes）、后代（descendant）或同胞（ sibling）选择符组合的话，考虑为你希望匹配的元素标签加一个类。

	/* bad */
	div:first-of-type :last-child > p ~ *

	/* good */
	div:first-of-type .info

Avoid overloading your selectors when you don't need to.  不必要的时候避免选择符过载。（**译注：CSS选择符过载是什么？只知道 override。**）

    /* bad */
    img[src$=svg], ul > li:first-child {
      opacity: 0;
    }

    /* good */
    [src$=svg], ul > :first-child {
      opacity: 0;
    }

特指度（Specificity）
Don't make values and selectors hard to override. Minimize the use of id's and avoid !important.
别让值和选择符难以重载。减少ID的使用，避免使用`!important`。

    /* bad */
    .bar {
      color: green !important;
    }
    .foo {
      color: red;
    }

    /* good */
    .foo.bar {
      color: green;
    }
    .foo {
      color: red;
    }

 层叠（Overriding）
 Overriding styles makes selectors and debugging harder. Avoid it when possible.
 层叠样式会使选择符和调试更加复杂困难。尽可能避免使用。

 	/* bad */
	li {
	  visibility: hidden;
	}
	li:first-child {
	  visibility: visible;
	}

	/* good */
	li + li {
	  visibility: hidden;
	}
继承（Inheritance）
Don't duplicate style declarations that can be inherited.
能继承的样式声明就别复制。

	/* bad */
	div h1, div p {
	  text-shadow: 0 1px 0 #fff;
	}

	/* good */
	div {
	  text-shadow: 0 1px 0 #fff;
	}

简洁（Brevity）
Keep your code terse. Use shorthand properties and avoid using multiple properties when it's not needed.
保持代码的简洁。使用简写的属性，不必要时避免使用多重属性。

	/* bad */
	div {
	  transition: all 1s;
	  top: 50%;
	  margin-top: -10px;
	  padding-top: 5px;
	  padding-right: 10px;
	  padding-bottom: 20px;
	  padding-left: 10px;
	}

	/* good */
	div {
	  transition: 1s;
	  top: calc(50% - 10px);
	  padding: 5px 10px 20px;
	}

语言（Language）
Prefer English over math.

	/* bad */
	:nth-child(2n + 1) {
	  transform: rotate(360deg);
	}

	/* good */
	:nth-child(odd) {
	  transform: rotate(1turn);
	}

浏览器前缀（Vendor prefixes）
Kill obsolete vendor prefixes aggressively. If you need to use them, insert them before the standard property.
竭力地干掉过时的浏览器前缀吧！必须使用的话，把它们写在标准属性前。

	/* bad */
	div {
	  transform: scale(2);
	  -webkit-transform: scale(2);
	  -moz-transform: scale(2);
	  -ms-transform: scale(2);
	  transition: 1s;
	  -webkit-transition: 1s;
	  -moz-transition: 1s;
	  -ms-transition: 1s;
	}

	/* good */
	div {
	  -webkit-transform: scale(2);
	  transform: scale(2);
	  transition: 1s;
	}

动画（Animation）
Favor transitions over animations. Avoid animating other properties than opacity and transform.
除了`opacity` 和 `transform`，其他尽量使用`transition`，而不是`animation`。

单位（Units）
能不带单位就不带单位。相对单位多用`rem`。多用`s`而不是`ms`。（**why?**）

	/* bad */
	div {
	  margin: 0px;
	  font-size: .9em;
	  line-height: 22px;
	  transition: 500ms;
	}

	/* good */
	div {
	  margin: 0;
	  font-size: .9rem;
	  line-height: 1.5;
	  transition: .5s;
	}

颜色（Colors）
需要改变透明度（transparency）时，使用`rgba`。否则永远使用十六进制值（hexadecimal format）。

	/* bad */
	div {
	  color: hsl(103, 54%, 43%);
	}

	/* good */
	div {
	  color: #5a3;
	}

绘图（Drawing）
资源使用CSS绘图替代的话可以避免HTTP请求。

	/* bad */
	div::before {
	  content: url(white-circle.svg);
	}

	/* good */
	div::before {
	  content: "";
	  display: block;
	  width: 20px;
	  height: 20px;
	  border-radius: 50%;
	  background: #fff;
	}
技巧（Hacks）
别用。

	/* bad */
	div {
	  // position: relative;
	  transform: translateZ(0);
	}

	/* good */
	div {
	  /* position: relative; */
	  will-change: transform;
	}

JavaScript
---
性能（Performance）
Favor readability, correctness and expressiveness over performance. JavaScript will basically never be your performance bottleneck. Optimize things like image compression, network access and DOM reflows instead. If you remember just one guideline from this document, choose this one.
易读性、正确性、富有表现性比性能更重要。从根本上来说，JavaScript绝对不会成为性能瓶颈，应该优化图像压缩、网络连接和DOM刷新。如果你只记得这篇文档的一条规则，那就选择这条吧。

	// bad (albeit way faster)
	const arr = [1, 2, 3, 4];
	const len = arr.length;
	var i = -1;
	var result = [];
	while (++i < len) {
	  var n = arr[i];
	  if (n % 2 > 0) continue;
	  result.push(n * n);
	}

	// good
	const arr = [1, 2, 3, 4];
	const isEven = n => n % 2 == 0;
	const square = n => n * n;

	const result = arr.filter(isEven).map(square);

无国籍？（Statelessness）
Try to keep your functions pure. All functions should ideally produce no side-effects, use no outside data and return new objects instead of mutating existing ones.
尽量使函数纯粹。理想情况下，所有的函数都不会产生副作用，不使用外部的数据，返回新的对象而不是在现有对象上作修改。

	// bad
	const merge = (target, ...sources) => Object.assign(target, ...sources);
	merge({ foo: "foo" }, { bar: "bar" }); // => { foo: "foo", bar: "bar" }

	// good
	const merge = (...sources) => Object.assign({}, ...sources);
	merge({ foo: "foo" }, { bar: "bar" }); // => { foo: "foo", bar: "bar" }

原生（Natives）
尽可能使用原生方法。

	// bad
	const toArray = obj => [].slice.call(obj);

	// good
	const toArray = (() =>
	  Array.from ? Array.from : obj => [].slice.call(obj)
	)();

强制转换（Coercion）
有意义的时候就欣然使用「隐式类型转换」（imolicit coercion）吧，不然就避免它。Don't cargo-cult. （别太草包，要灵活变通？）

	// bad
	if (x === undefined || x === null) { ... }

	// good
	if (x == undefined) { ... }

循环（Loops）
Don't use loops as they force you to use mutable objects. Rely on `array.prototype` methods.
不要使用循环因为它强制你使用可变的对象。使用`array.prototype`方法。

	// bad
	const sum = arr => {
	  var sum = 0;
	  var i = -1;
	  for (;arr[++i];) {
	    sum += arr[i];
	  }
	  return sum;
	};

	sum([1, 2, 3]); // => 6

	// good
	const sum = arr =>
	  arr.reduce((x, y) => x + y);

	sum([1, 2, 3]); // => 6
If you can't, or if using `array.prototype` methods is arguably abusive, use recursion.
不能的话，或者可以说 `array.prototype` 被滥用，就使用递归（recursion）。

	// bad
	const createDivs = howMany => {
	  while (howMany--) {
		document.body.insertAdjacentHTML("beforeend", "<div></div>");
	  }
	};
	createDivs(5);

	// bad
	const createDivs = howMany =>
	  [...Array(howMany)].forEach(() =>
	    document.body.insertAdjacentHTML("beforeend", "<div></div>")
	  );
	createDivs(5);

	// good
	const createDivs = howMany => {
	  if (!howMany) return;
	  document.body.insertAdjacentHTML("beforeend", "<div></div>");
	  return createDivs(howMany - 1);
	};
	createDivs(5);

参数（Arguments）
Forget about the `arguments` object. The rest parameter is always a better option because:

1. it's named, so it gives you a better idea of the arguments the function is expecting
2. it's a real array, which makes it easier to use.
忘掉 `arguments` 对象吧。参数名（rest parameter）总是个更好的选择。原因如下：
1. 命名的参数能让你更好理解这个函数期待输入的参数；
2. 命名的参数是一个真正的数组，这样使用它更容易。

		// bad
		const sortNumbers = () =>
	  		Array.prototype.slice.call(arguments).sort();

		// good
		const sortNumbers = (...numbers) => numbers.sort();

Apply
忘掉`apply()`吧，使用更广泛的操作符（spread operator）。

	const greet = (first, last) => `Hi ${first} ${last}`;
	const person = ["John", "Doe"];

	// bad
	greet.apply(null, person);

	// good
	greet(...person);

Bind
Don't `bind()` when there's a more idiomatic  approach.
有更符合语言习惯的方法的时候，不要用`bind()`。

	// bad
	["foo", "bar"].forEach(func.bind(this));

	// good
	["foo", "bar"].forEach(func, this);

	// bad
	const person = {
	  first: "John",
	  last: "Doe",
	  greet() {
	    const full = function() {
	      return `${this.first} ${this.last}`;
	    }.bind(this);
	    return `Hello ${full()}`;
	  }
	}

	// good
	const person = {
	  first: "John",
	  last: "Doe",
	  greet() {
	    const full = () => `${this.first} ${this.last}`;
	    return `Hello ${full()}`;
	  }
	}

高阶函数（Higher-order functions）
尽量不要嵌套函数（nesting functions）。

	// bad
	[1, 2, 3].map(num => String(num));

	// good
	[1, 2, 3].map(String);

组合（Composition）
Avoid multiple nested function calls. Use composition instead.
 避免多重嵌套的函数调用。改用`composition`。

	const plus1 = a => a + 1;
	const mult2 = a => a * 2;

	// bad
	mult2(plus1(5)); // => 12

	// good
	const pipeline = (...funcs) => val => funcs.reduce((a, b) => b(a), val);
	const addThenMult = pipeline(plus1, mult2);
	addThenMult(5); // => 12

缓存（Caching）
Cache feature tests, large data structures and any expensive operation.
将重要的测试、大块的数据结构或者任何高代价的运算操作都缓存起来。

	// bad
	const contains = (arr, value) =>
	  Array.prototype.includes
	    ? arr.includes(value)
	    : arr.some(el => el === value);
	contains(["foo", "bar"], "baz"); // => false

	// good
	const contains = (() =>
	  Array.prototype.includes
	    ? (arr, value) => arr.includes(value)
	    : (arr, value) => arr.some(el => el === value)
	)();
	contains(["foo", "bar"], "baz"); // => false

变量（Variables）
Favor const over let and let over var.
优先级：`const` > `let` > `var`

	// bad
	var obj = {};
	obj["foo" + "bar"] = "baz";

	// good
	const obj = {
	  ["foo" + "bar"]: "baz"
	};

条件（Conditions）
Favor IIFE's and return statements over if, else if, else and switch statements.
优先级：`IIFE`+ `return` > `if` + `else if` + `switch`
译注：`IIFE`： Immediately-invoked function expression，立即调用的函数表达式；


	// bad
	var grade;
	if (result < 50)
	  grade = "bad";
	else if (result < 90)
	  grade = "good";
	else
	  grade = "excellent";

	// good
	const grade = (() => {
	  if (result < 50)
	    return "bad";
	  if (result < 90)
	    return "good";
	  return "excellent";
	})();

对象迭代（Object iteration）
Avoid for...in when you can.
避免使用`for-in`

	const shared = { foo: "foo" };
	const obj = Object.create(shared, {
	  bar: {
	    value: "bar",
	    enumerable: true
	  }
	});

	// bad
	for (var prop in obj) {
	  if (obj.hasOwnProperty(prop))
	    console.log(prop);
	}

	// good
	Object.keys(obj).forEach(prop => console.log(prop));

Objects as Maps
While objects have legitimate use cases, maps are usually a better, more powerful choice. When in doubt, use a Map.
尽管`objects`有些好的使用案例，但`maps`通常是一种更好更强大的选择。

	// bad
	const me = {
	  name: "Ben",
	  age: 30
	};
	var meSize = Object.keys(me).length;
	meSize; // => 2
	me.country = "Belgium";
	meSize++;
	meSize; // => 3

	// good
	const me = Map();
	me.set("name", "Ben");
	me.set("age", 30);
	me.size; // => 2
	me.set("country", "Belgium");
	me.size; // => 3

柯里化（Curry）
Currying might have its place in other languages, but avoid it in JavaScript. It makes your code harder to read by introducing a foreign paradigm while the appropriate use cases are extremely unusual.
在其他语言中，柯里化可能有它的一席之地，但是不要在 JavaScript 中使用它。因为它引入了很少能见到正确使用的非自身范例（foreign paradigm），这会让你的代码阅读困难。

	// bad
	const sum = a => b => a + b;
	sum(5)(3); // => 8

	// good
	const sum = (a, b) => a + b;
	sum(5, 3); // => 8

可读性（Readability）
Don't obfuscate the intent of your code by using seemingly smart tricks.
别用些自作聪明的小把戏混淆了你代码真正的意图。

	// bad
	foo || doSomething();

	// good
	if (!foo) doSomething();


	// bad
	void function() { /* IIFE */ }();

	// good
	(function() { /* IIFE */ }());

	// bad
	const n = ~~3.14;

	// good
	const n = Math.floor(3.14);

代码复用（Code reuse）
Don't be afraid of creating lots of small, highly composable and reusable functions.
尽管去写些短小精悍、组件化、高度复用的函数。

	// bad
	arr[arr.length - 1];

	// good
	const first = arr => arr[0];
	const last = arr => first(arr.slice(-1));
	last(arr);


	// bad
	const product = (a, b) => a * b;
	const triple = n => n * 3;

	// good
	const product = (a, b) => a * b;
	const triple = product.bind(null, 3);

依赖（Dependencies）
Minimize dependencies. Third-party is code you don't know. Don't load an entire library for just a couple of methods easily replicable:
精简依赖。你都不知道第三方有些什么代码。
能自己写些简单方法替代就别载入整个库。

	// bad
	var _ = require("underscore");
	_.compact(["foo", 0]));
	_.unique(["foo", "foo"]);
	_.union(["foo"], ["bar"], ["foo"]);

	// good
	const compact = arr => arr.filter(el => el);
	const unique = arr => [...Set(arr)];
	const union = (...arr) => unique([].concat(...arr));

	compact(["foo", 0]);
	unique(["foo", "foo"]);
	union(["foo"], ["bar"], ["foo"]);
