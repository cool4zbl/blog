---
title: Oh My Ghostium
tags: tech, frontend, thoughts 
---
  
之前装了Wordpress扔在大洋彼岸一个Arizona搬瓦工的VPS后就再没去理过它，想想也有半年了。  
后来分析觉得，首先肯定是自己懒惰浮躁，静不下来写东西。其次是博客页面没有漂亮到让我有一种打开就想写的冲动。  
但是他们说**[为什么你应该（从现在开始就）写博客](http://mindhacks.cn/2009/02/15/why-you-should-start-blogging-now/)**，于是紧跟大牛的步伐，虽然没有什么牛逼技术可以跟别人分享，但是看看大牛写的技术文章谢谢心得也是一种进步。于是就开始了*万劫不复的折腾深渊*...  
在谷歌搜寻平台的时候看到了一个同是F2E的一个博客[罗磊的独立博客](http://luolei.org)，瞬间被大Banner的设计吸引到，看了很久后拖到了网页末尾，扫到了一行字*本博客基于拽酷炫的 GHOST*。   
比较了*Ghost/Jekyll/Octo/Hexo* 等等之后，认为**[Ghost](https://ghost.org)**还是最适合我： 

1. 是基于 **Node.js** 的博客平台。
2. **Just a blogging platform.**简单简洁，响应式设计。
3. 免费，**支持完全的自定义**。
  
DigitalOcean很贴心的有Ghost的APP安装镜像包，安装后直接打开```http://your.domain/2368```就会看到第一次登陆的窗口，设置好Blog Title，用户名，密码就可以愉快的开始体验Ghost了。  
又过了几天，手贱点开了很多Ghost类的博客，发现大家怎么都这样啊，使用默认的Casper主题已到审美疲劳。  
在连博文都没写几篇的情况下，那么就继续*万劫不复的折腾深渊* 咯。  


很喜欢**[Medium](https://medium.com/)**那个网站的设计风格，漂亮的排版和字体，恰当的行高，带有震撼般视觉冲击的大Banner图片...[^1]
[^1]: 知乎[怎样评价Medium的设计](http://zhi.hu/1Ed2) 
感觉一切的设计都如此恰到好处（一股浓浓的高逼格气息扑面而来）。
谷歌搜索类Medium的Ghost主题，
<b> **[Ghostium](http://ghostium.oswaldoacauan.com/)**, a medium-like theme.
</b>
先给作者[@oswaldoacauan](https://twitter.com/oswaldoacauan)各种点赞，想要的样式全都有。
但是在网站上跑了一会后，发现有些细节地方还是不尽入我意。  
那么，还是自己动手丰衣足食，开始*万劫不复的折腾深渊* 第四弹。
一边看[Ghost Developer Documentation](http://themes.ghost.org/v0.5.3/docs/about)、[Handelbars.js Guide](http://handlebarsjs.com/)，一边用自学的一点点 HTML&CSS&JS 来调试和修改原主题。

---

**- HTML**

1. 修改Drawer侧栏的导航（Navigation.hbs），增加Links如下:

```  
<li class="drawer-list-item">
  <a href="/" data-pjax>
    <i class="fa fa-home"></i>Home
  </a>
</li>
<li class="drawer-list-item">
  <a href="{{@blog.url}}/timeline/">
    <i class="fa fa-clock-o"></i>Timeline
  </a>
</li>
<li class="drawer-list-item">
  <a href="{{@blog.url}}/wiki/">
    <i class="fa fa-coffee"></i>Wiki
  </a>
</li>
<li class="drawer-list-item">
  <a href="{{@blog.url}}/book/">
    <i class="fa fa-camera-retro"></i>Portfolio
  </a>
</li>
<li class="drawer-list-item">
  <a href="{{@blog.url}}/about/">
    <i class="fa fa-comment-o"></i>About Me
  </a>
</li>
<li class="drawer-list-item">
  <a href="{{@blog.url}}/rss/">
    <i class="fa fa-rss"></i>Subscribe to Feed
  </a>
</li>

<li class="drawer-list-divider"></li>
<li class="drawer-list-item drawer-list-title">
  Follow me
</li>
<li class="drawer-list-item">
  <a href="http://twitter.com/cool4zbl" target="_blank">
    <i class="fa fa-twitter"></i>Twitter
  </a>
</li>
<li class="drawer-list-item">
  <a href="http://github.com/githubzbl" target="_blank">
    <i class="fa fa-github"></i>Github
  </a>
</li> 
```

2. 在博客文章内容页（post.hbs）删除了分享到G+图标，增加了分享到微博图标：  
 ``` language-html
<a href="#" data-action="share-weibo"><i class="fa fa-fw fa-lg fa-weibo"></i></a> 
```

CSS(main.css)  
1. 字体类型及大小。  
原来的字体太小，而且因为主题原作者不说汉语，所以默认在主题内显示的汉字为宋体，且行高较小，不方便阅读。发现这么几篇文章：[web中文字体应用指南](https://ruby-china.org/topics/14005)//[適合閱讀的中文字體](http://lepture.com/zh/2014/chinese-fonts-and-yue-css)//[網頁上95%的內容其實都是"typography“](http://informationarchitects.net/blog/the-web-is-all-about-typography-period/) 
 特别是第二篇。于是根据自己的喜好，同时照顾到广大Mac、Windows用户，字体样式如下：  
```language-css
/* 文章内容 衬线字体 */
body {
    font: 400 20px/1.62 "Lora", Georgia, "Xin Gothic", "STXihei", Cambria, "Droid Sans Fallback", "Microsoft YaHei", sans-serif;
    background: #fff;
    color: #333
}
/* 文章标题、按钮等 非衬线 */  
font-family: "Lato","Myriad Pro","Lucida Grande","Lucida Sans Unicode","Lucida Sans",Geneva,Verdana,sans-serif;
/* Footer底部字体 Optima更为优雅低调 */
font-family: Optima, sans-serif;
```   

注："Xin Gothic" 信黑体；"STXihei" 华文细黑；"Hiragino Sans GB" 冬青黑体  
**Lato & Lora** 同为 Transitional Fonts。[Foundamentals of Design by code school](https://www.codeschool.com/courses/fundamentals-of-design)

2. 主页（index.hbs）的封面/边距/文章摘要  
	- 原来的```cover```大概占据了页面的30%，看起来图片有点喧宾夺主，经过反复折腾后，觉得25%的比例最不错。  
	```language-css
	.cover {
    position: relative;
    top: 0;
    left: 0;
    width: 25%;
    height: 100%;
    z-index: 100
	}```  
	- 主页右侧文章内容偏上，如果是英文内容还好，但是中文的话感觉一块块的，特别突兀，调整```padding```，使内边距更大。反复比较后，6%看起来最自然。
	```language-css 
	.wrapper-container {
    position: relative;
    padding: 6% 10% 40px 185px;
    max-width: 910px
}```
   - 主页右侧的文章摘要(post/list.hbs)原来为  
   ```<section itemprop="description" class="post-item-excerpt">
    <p>{{excerpt words="35"}}&hellip;</p>
  </section>```

	如果是英文内容还好，但是对于中文内容，Ghost貌似对这个支持不太好（因为是按空格来计算word数量），所以显示的摘要往往会过多，查看文档后发现有另一种```character```字符数计数方式。很高兴地修改如下：  
	```  <section itemprop="description" class="post-item-excerpt">
    <p>{{excerpt characters="140"}}&hellip;</p>
  </section>```
  
3. 全局导航栏(drawer.hbs)  
	每个导航栏(.drawer-list-item)字体过小，且挨得太近。参考了一下我最喜欢的**Medium**设计后，修改如下：  
```language-css
	 .drawer-list-item {
    font-family: "Lato","Myriad Pro","Lucida Grande","Lucida Sans Unicode","Lucida Sans",Geneva,Verdana,sans-serif;
    font-weight: 600;
    font-size: .9em;
    color: #9c9c9c;
    line-height: 2.2;
	}```

4. 博客内容分页(post.hbs)  
	对于作者的头像```.post-author-avatar```，原作者可能了为了保证质量，头像不被随意拉伸，```language-css .post-author-avatar { width: 100%; height: 100%; border-radius: 100% }```，采取了长宽度100%，但是四个角自然圆角，所以如果传的头像是矩形就会出现椭圆形的效果，但是个人觉得还是圆形头像更精致。所以为了保证无论上传何种比例的图片，得到的都是圆形的头像，那么就采用固定长宽度（此处在看Ghost后台时候，发现默认的作者头像就是圆形，查看源代码发现使用的是```js-model-image```，涉及到JS还未深入研究）。   
	```language-css 
	.post-author-avatar {
    width: 80px;
    height: 80px;
    display: block;
    margin-bottom: 10px
	} ```

---
大体地方修改完毕，把修改后主题上传到VPS，重启Ghost服务（Ghost无法实时探测到```content/theme/```内容改变）。  
Well done.

优化：  
对于谷歌字体在国内~~访问速度不佳~~无法访问，使用了[360网站卫士加速库](http://libs.useso.com/) ```language-html <link href="//fonts.useso.com/css?family=***">```

待解决问题：
- 微博官方的分享按钮太花哨，想使用FontAwesome的图标但还未解决如何触发微博分享；  
- 把博客内容页面```post```样式从```main.css```中分离出来，方便以后Ghost升级做*所见即所得* (but we highly recommend keeping your post styles in a separate file (post.css) from other styles for your theme (style.css) so that you will quickly be able to take advantage of this feature in the future.)；  
- 在```post```页面加入一个返回顶部的小箭头；  
- 在```post```页面应用类似于Medium文章打开后顶部为震撼图片的大Banner。 
- 学习使用JS-model-image 自动切割Avatar及Logo  
- Navigation各种链接网页的相关建设及完善  
- 博文搜索  
- 画个网站结构图 site-map



