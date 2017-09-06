---
title: Ali校招笔试题思考
published_at: 01 Dec 14 @ 20:13
tags: interview, tech, frontend
---

# Ali校招笔试题思考

昨晚搭着末班车，参加了阿里今年的实习生在线笔试。
回忆之前惨不忍睹的内推面试，玩了整整一个寒假后接到了不期而至的面试电话，连之前一些基础的还算熟悉的题都答得不流畅自然一气呵成，我就知道我悲剧了。
痛定思痛，作为一个即将毕业的大四老鸟（只是说年龄...)，在被各种鄙视，各种蜚语，各种不确定存在的黑暗时期，依旧不屈不挠地学习思考着，我都要被自己感动了。
笔试题只有一个小时，13道题，一开始是单项选择和不定项选择，考了AMD编码规范、闭包、setTimeout的异步、前端安全及一些我认为蛮有意思的小题，挺考基础的，不是太难，但要细心，我居然也慢悠悠做，时间就那么过去了一半。后来看到了六大道问答题，基本是编程，涉及CSS3、原生JS、事件处理、Ajax等，就渐渐慌了，写代码的手居然有了渐冻症的感觉，心理素质有待提高。
于是在有差不多一半大题没完成的情况下，被迫交了卷。交卷后才灵感突现，猛然想起了那些题的解法，还是代码经验不够啊。为了防止再出现这样的情况，在这里贴下题目思路和解答。

---
关于CSS，有题是用`HTML&CSS`实现一个九宫格，外边框为1px，内部无边框。之前没有做过九宫格布局，当时又很捉急居然被卡住了。交完卷后突然在想，这不就是考`float`的嘛。
遂编码如下：
```language-html
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>九宫格</title>
	<style>
      ul {
          list-style: none;
          width: 158px;
          height: 158px;
      }
      li {
          width: 50px; height: 50px;
          /*box-sizing: border-box;*/
          background-color: #888;
          float: left;
      }
      .one,.four, .seven{
      border-left: 3px solid red;
          /*z-index: 2;*/
      }
      .one, .two, .three {
          border-top: 3px solid red;
      }
      .three, .six, .nine {
          border-right: 3px solid red;
      }
      .seven, .eight, .nine {
          border-bottom: 3px solid red;
      }

	</style>
</head>
<body>
	<p>
	HTML CSS 九宫格 外边框1px 内部无边框
	</p>
    <ul class="list">
        <li class="one"></li>
        <li class="two"></li>
        <li class="three"></li>
        <li class="four"></li>
        <li class="five"></li>
        <li class="six"></li>
        <li class="seven"></li>
        <li class="eight"></li>
        <li class="nine"></li>
    </ul>

</body>
</html>

```
其实就是每个盒子固定宽高，父元素也固定宽高，分别为盒子宽高的3倍+左右（或上下）两边的边框宽度，然后都浮动起来。内部无边框外部有边框也容易实现，只要把最外圈的盒子按顺序设定 `border-top`、`border-bottom`、`border-left`、`border-right`即可。
思考：

- 一开始把父元素刚好设为盒子宽高的3倍，盒子设定为`box-sizing: border-box`后，发现边框自动隐藏了，所以要体现有边框还是不能这样；
- 该题不难，其实还可以拓展成N宫格，`父元素的宽高 = N*盒子宽高 + 2*border-width`，相当于做个图片墙。

JS跨浏览器事件处理：给你个超链接按钮，用户点击后不进行链接跳转，而是提示“用户名不能为空”，要尽可能兼容更多的浏览器。
这题考的也就是跨浏览器的事件处理啦，之前看过《JavaScript高级程序设计》时候，专门有一小节讲跨浏览器事件处理，给出了完整的解决方案，自己也用心写了`Code Snippet`笔记，但是实践少，考试时做的不太顺利，这里重新整理下贴下代码。
（Ghost Gist 托管，若无显示请戳 [跨浏览器事件处理Gist](https://gist.github.com/githubzbl/8170f1e96e7bf3c66ca5)）
<script src="https://gist.github.com/githubzbl/8170f1e96e7bf3c66ca5.js"></script>

思考：

- 事件处理很简单，关键就在兼容浏览器，这里就得照顾到IE；
- 当时考试时居然把`<script>`标签及其里面的代码写到了`<head>`里面，导致`document.getElementById('btn')`返回的一直是`undefined`，现在想想给自己跪了，`DOM`都没准备好哪来的`getElementById()`。

JS统计字符串中出现次数最多的字符并打印统计信息。
这题当时看的时候居然看成*找出现最多的字符串*，心想天哪噜大阿里真厉害前端还考字符子串问题，这算法……，时间紧迫，遂想都没想直接跳过了。交卷后仔细回想才发现是*找字符*啊！再给自己跪下\*2。
在老道那本《Good Parts》里有个gist是去计算一段文本中每个单词的出现次数，因为每个单词是用空格符隔开，所以思路也可以迁移到单个字符。思考后编码如下：
（Ghost Gist 托管，若无显示请戳 [字符计数](https://gist.github.com/githubzbl/a0ab1b7dd4f0128e9d6d)）
<script src="https://gist.github.com/githubzbl/a0ab1b7dd4f0128e9d6d.js"></script>
思考：

- 将字符串分成单个字符很简单，甚至不用`RegExp`；
- 分成单个字符后存入一个对象，巧妙的是对象的属性即为该字符，属性值为该字符在字符串中出现的次数；
- 最后简单的用`for in`遍历属性排序，当然老道说`for in`不好，不知道这个地方需不需要改善。

JS 给定一个http接口，传入一个员工id，返回员工的详细信息，接口形式为：`http://localhost/query?id=`，要求在前端实现一个根据一批员工id，通过ajax查询员工信息的功能。
Ajax show time, finally.
之前只写过几个Ajax，并不是太熟练，所以这题拿不准。
既然给了URL，一般就是要考`RegExp`啦，但是这个只要根据`id`查询就好，是不是只用`url.split('=')`，然后就知道ID了呢？
HTTP接口应该也就是写个函数模块吧。暂时给思路如下，待完善。
```language-javascript```
 $(document).ready(function(url) {
   var id = url.split('=')[1];
   $('.btn').click(function (id) {
        $.ajax({
            url: 'http://localhost/query?id=',
            type: 'GET',
            dataType: 'html',
            data: {param1: id},
        })
        .done(function() {
            console.log("success");
        })
        .fail(function() {
            console.log("error");
        })
        .always(function() {
            console.log("complete");
        });
    });
  });
```
---

差不多就这些了，想到新思路再来更新吧。前端坑是很多，但也很有趣，感觉自己终于入门了呢。
还是那句，希望自己在成为大牛的道路上越走越远。

---
续：觉得做的一般也收到了面试通知。但阿里又说“针对2015届招聘已结束，无论面试结果如何我们都不能承诺您能加入”。伤心归伤心，毕竟迟了那么点。
但再怎么着也要执着走下去。
**“It's never too late to start.”**

