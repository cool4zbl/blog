---
title: 前后端数据交互 - 表单提交
tags: tech, frontend, ajax
time: 10 August 2017 at 11:55 AM
---



最近想总结下前后端数据交互方式，顺便继续学习下网络相关，以下是第一篇，最简单、最常见且应用最广泛的「表单提交」。

按交互方式分为两种，提交后有刷新的普通表单提交和无刷新的 Ajax 表单提交。

## 1. 普通表单提交

下面是一个很普通的用户登录表单：

```html
<form class="form login-form" id="loginForm"
      method="POST" action="api.test.com/login">
  <label for="name">Username</label><input type="email" id="name">
  <label for="password">Password</label><input type="password" id="password">
  <label for="captcha">Captcha</label><input type="text" id="captcha">

  <label for="selLoc">Location</label>
  <select name="location" id="selLoc">
    <option value="cn">China Mainland</option>
    <option value="hk">Hong Kong</option>
    <option value="tw">Tai Wan</option>
    <option value="us">America</option>
    <option value="jp">Japan</option>
    <option value="">Somewhere</option>
    <option >Anywhere</option>
  </select>

  <!--  General submit button  -->
  <input type="submit" value="Submit Form">
  <!--  Customize  -->
  <button type="submit">Submit Form</button>
  <!--  Image button   -->
  <input type="image" src="graphic.gif">
</form>
```

- 当用户单击提交按钮或者图像按钮的时候，就会提交表单；

- `<input type="submit">` / `<button type="submit">` / `<input type="image" src='img.gif'>` 都可以作为表单提交按钮。且只要存在任何一种按钮，在相应表单控件有焦点的情况下，按回车键就可以提交该表单，这里应该是浏览器对表单元素回车键的默认行为，所以在提交表单前，会触发 `submit Event`，可以用来做表单验证；

- 如果直接使用 JS `submit()` 提交表单，这里则不会触发表单的 `submit Event`，所以需要在调用方法前做表单验证；

  ```javascript
  let form = document.getElementById('loginForm')
  form.submit()
  ```

- 以上的方法提交表单，就是一个普通的表单提交，会触发浏览器提交表单的默认行为：刷新页面！用户体验也将大打折扣。所以出现了优化版的 Ajax 表单提交。



## 2. Ajax 表单提交

仍然是上面的表单元素，因为 ajax 时候可以指定 URL，所以这里的表单元素可以省略 `action` 属性。

```html
<form class="form login-form" id="loginForm" method="POST">
  <label for="name">Username</label><input type="email" id="name">
  <label for="password">Password</label><input type="password" id="password">
  <label for="captcha">Captcha</label><input type="text" id="captcha">

  <label for="selLoc">Location</label>
  <select name="location" id="selLoc">
    <option value="cn">China Mainland</option>
    <option value="hk">Hong Kong</option>
    <option value="tw">Tai Wan</option>
    <option value="us">America</option>
    <option value="jp">Japan</option>
    <option value="">Somewhere</option>
    <option >Anywhere</option>
  </select>

  <!--  General submit button  -->
  <input type="submit" value="Submit Form">
  <!--  Customize  -->
  <button type="submit">Submit Form</button>
  <!--  Image button   -->
  <input type="image" src="graphic.gif">
</form>
```



我们可以利用每个表单字段的 `type` 属性，连同 `name` 和 `value` 属性一起实现对表单的序列化。先了解下浏览器将数据发送给服务器的过程如下：

> - 对表单字段的名称和值进行 URL 编码，使用和号(&) 分隔。
>
> - 不发送禁用的表单字段。
>
> - 只发送勾选的复选框和单选按钮。
>
> - 不发送 type 为 "reset" 和 "button" 的按钮 。
>
> - 多选选择框中的每个选中的值单独一个条目。
>
> - 在单击提交按钮提交表单的情况下，也会发送提交按钮；否则，不发送提交按钮。也包括 type
>
>   为 "image" 的`<input>`  。
>
> - `<select> ` 的值，就是选中的 `<option>`  元素的 value 特性的值。如果 `<option>`  没有
>
>   value 特性，则是 `<option>` 元素的文本值。
>
> — — 《JavaScript 高级程序设计》

在表单序列化的过程中，一般不包含任何按钮字段，因为结果字符串很可能是通过其他方式提交的，除此之外其他规则都应该遵循。以下就是实现表单序列化的代码。

```javascript
// ref: Professional JavaScript Ch14.4
function serialize(form) {
  let parts = [],
      field = null,
      option, optValue

  for (let i = 0, len = form.elements.length; i < len; i++) {
    field = form.elements[i]

    switch(field.type) {
      // select elements
      case 'select-one':
      case 'select-multiple':
        if (field.name.length) {
          for (let j = 0, optLen = field.options.length; j < optLen; j++) {
            option = field.options[j]
            if (option.selected) {
              // DOM
              optValue = ''
              if (option.hasAttribute) {
                optValue = option.hasAttibute('value')
                  ? option.value : option.text
              } else {
                // IE
                optValue = option.attributes['value'].specified
                  ? option.value : option.text
              }
              parts.push(encodeURIComponent(filed.name) + "=" + encodeURIComponent(optValue))
            }
          }
        }
        break
      case undefined:
      case 'file':  // files input
      case 'submit': // submit buttons
      case 'reset': // reset buttons
      case 'button': // customize buttons
        break

      case 'radio':  // radio buttons
      case 'checkbox':  // checkbox
        if (!field.checked) {
          break
        }
      default:
        // excluding no name field
        if (field.name.length) {
          parts.push(encodeURIComponent(filed.name) + "=" + encodeURIComponent(optValue))
        }
    }
  }
  return parts.join('&')
}
```

回到用户登录场景，当用户填写了表单字段，`name` 为 `cool4zbl`，`password` 为 `secret@Pass` ，选择 `location` 为`America`，然后点击 `submit` 按钮提交表单。我们可以监听到 `submit Event`，拦截默认的表单提交事件，然后在提交表单前执行 `serialize(document.getElementById('loginForm'))` ，将会返回

`name=cool4zbl&password=sercret%40Pass&location=America`，然后就可以使用 Ajax Post 序列化后的数据到服务器，根据服务器端返回的信息（一般为`json`格式）来显示是否登录成功或者是出现了错误。

```javascript
let form = document.getElementById('loginForm')
form.onsubmit = (e) => {
  e.preventDefault()
  const data = serialize(form)
  $.ajax({
    data,
    url: 'api.test.com',
    type: form.getAttribute('method'),
    contentType: 'application/json; charset=UTF-8',
    dataType: 'json',
    success: function(resData) {
      // do something with success resData
      // blah
    },
    error: function(xhr, type) {
      // Oops, something wrong occurs...
    }
  })
}
```

这里为了专注于解释提交表单前后浏览器的行为，使用 jQuery ajax API 简化了具体前后端 Ajax 通信时候发生了什么。

**表单提交**这应该是前端应该掌握的最基本，也是应用得最广泛的前后端数据交互方式了。

当然还有浏览器通信时的一些坑会被踩到，需要去填，所以更详细的 Ajax 通信总结请参考下一篇「前后端数据交互 - Ajax」。



以上。
