---
title: Oops...DevOps
published_at: 21 Oct 16 @ 01:41
---

# Oops...DevOps

![](/content/images/2016/10/13696947_266466680392407_1036551811_n-1.jpg)

晚上花时间来清理邮箱，查收到了 DNSPod 发来的一堆监控警告邮件，才突然发现自己长草多年的博客已经宕机半个月之余！<br>
迅速打开博客地址，大写的 **502 Bad Gateway** 与 Nginx 更配噢。现在就是有台强力除草机也没用了。<br>
亏我还一直按时给 DO 充值打钱...

于是立马 `mosh` 到大洋彼岸的 VPS（这里还直接用的联通流量）， `service ghost restart && service nginx restart` 之后，502 仍然继续。

继续想起半个月前手贱升级了系统 Node 版本。
`node -v` 后发现已经是 `v6.3.x` 了，而 Ghost 现在[官方支持版本](http://support.ghost.org/supported-node-versions/)里并没有 `v6.x`，可能就是版本不兼容的问题。

通过 DO 官方 [Node 升级指南](https://www.digitalocean.com/community/questions/how-to-upgrade-node-js-on-older-ghost-droplets)，装好后虽然 `/usr/bin/node -v` 返回是 `v4.x` ，但 `which node` 及 `/usr/local/bin/node -v` 返回仍然为 `6.x`。那就指南暴力覆盖了！ `rm /usr/local/bin/npm && cp /usr/bin/node /usr/local/bin/node`， 一番更新修改后，`system node` 版本成功 downgrade 为 `v4.x`。

高兴地敲击 `npm start --production`，结果发现后面更多的坑需要填...

`npm start --production` 后，直接扔出了一个 `Node Error Stack` 如下：

```bash
Unhandled rejection Error: Cannot find module '[REDACTED]\node_modules\ghost\node_modules\sqlite3\lib\binding\node-v44-linux-x64\node_sqlite3.node'
    at Function.Module._resolveFilename (module.js:336:15)
    at Function.Module._load (module.js:286:25)
    at Module.require (module.js:365:17)
    at require (module.js:384:17)
    at Object.<anonymous> ([REDACTED]\node_modules\ghost\node_modules\sqlite3\lib\sqlite3.js:4:15)
    at Module._compile (module.js:430:26)
    at Object.Module._extensions..js (module.js:448:10)
    at Module.load (module.js:355:32)
    at Function.Module._load (module.js:310:12)
    at Module.require (module.js:365:17)
    at require (module.js:384:17)
    at Client_SQLite3.initDriver ([REDACTED]\node_modules\ghost\node_modules\knex\lib\dialects\sqlite3\index.js:41:24)
    at new Client_SQLite3 ([REDACTED]\node_modules\ghost\node_modules\knex\lib\dialects\sqlite3\index.js:15:10)
    at Knex.initialize ([REDACTED]\node_modules\ghost\node_modules\knex\knex.js:109:15)
    at Knex ([REDACTED]\node_modules\ghost\node_modules\knex\knex.js:13:26)
    at ConfigManager.set ([REDACTED]\node_modules\ghost\core\server\config\index.js:153:24)
    at ConfigManager.init ([REDACTED]\node_modules\ghost\core\server\config\index.js:76:10)
    at [REDACTED]\node_modules\ghost\core\server\config\index.js:267:30
    at tryCatcher ([REDACTED]\node_modules\ghost\node_modules\bluebird\js\main\util.js:24:31)
    at Promise._settlePromiseFromHandler ([REDACTED]\node_modules\ghost\node_modules\bluebird\js\main\promise.js:454:31)
    at Promise._settlePromiseAt ([REDACTED]\node_modules\ghost\node_modules\bluebird\js\main\promise.js:530:18)
    at Promise._settlePromises ([REDACTED]\node_modules\ghost\node_modules\bluebird\js\main\promise.js:646:14)
    at Async._drainQueue ([REDACTED]\node_modules\ghost\node_modules\bluebird\js\main\async.js:177:16)
    at Async._drainQueues ([REDACTED]\node_modules\ghost\node_modules\bluebird\js\main\async.js:187:10)
    at Immediate.Async.drainQueues [as _onImmediate] ([REDACTED]\node_modules\ghost\node_modules\bluebird\js\main\async.js:15:14)
    at processImmediate [as _immediateCallback] (timers.js:371:17)
```
（这里也可以 `tail -n 100 /var/log/ghost/error.log` 查看抛出的错误栈。）

唔，仔细看了下，可能是 npm 包没有完整装好，或者 npm 包的版本不兼容吧。
感谢 Google，找到了一个[类似的 issue](https://github.com/TryGhost/Ghost/issues/5911)，楼里恰好有一位遭遇同样情况的小哥，机智地解决了这个问题：

> Ghost supports node version 4.2.0 also. I was having this error "ERROR: Cannot find module '../../node_modules/sqlite3/lib/binding/node-v46-linux-x64/node_sqlite3.node' " .

> I just installed node version 4.2.0 using nvm and installed sqlite3. The "binding" folder inside sqlite3 got a node-v47 folder instead of v46. So I just renamed the folder to v46 and downloaded the node_sqlite3.node file from here http://www.unifieddigital.com/node_modules/sqlite3/lib/binding/node-v46-linux-x64/.

> THIS WORKED FOR ME.!!!

简直了，我真是感谢他，**THIS ALSO WORKED FOR ME!!!**

终于 `npm start --production` 可以成功跑起来 😆 ~ <br>
`Ctrl-c` 后，`service ghost restart`，刷新 Blog，啊哈哈，Welcome to Ghost ~

所以~~愉快流畅地~~升级到了 Ghost `v0.11.2` ...<br>
（官方也有一份关于 `SQLite3 Error` [TroubleShooting](http://support.ghost.org/troubleshooting/#sqlite3-errors)


但是注意，**备份**的重要性来了！

这里粗暴升级后，相当于是新装的 Ghost，打开 `{hostname}/ghost`，会需要你重新注册一个用户账号，也就是第一个注册的账号，会默认作为 Ghost `Owner`。但是这里什么数据都没有。打开 `ghost/data/` 或者 `ghost/content/theme/` 应该都是只有系统默认数据，而之前的那些用户数据都没有了。

还好我在之前就有想到自己有可能这么粗暴升级 Ghost，本地已经有了一份 `.json` 后缀的 exported data。于是在后台 `Settings -> Labs`，点击 `import data`，成功刷新后，之前所有备份过的博客文章数据都恢复啦！尽管我并不是什么高产博主，但是两年前才入门前端时，花心思写的一些东西说没就没也是一种遗憾。所以真是贴心的小功能。（不过这里的数据备份只包括 Post 数据，不包括 Theme / User Avatar 等，所以仍然需要 `cp -r myTheme/ theme/`，或者在后台 Settings -> General 上传主题图片和用户头像。）

搞定后，一切都恢复了日常。<br>
宕机这么久，DevOps 脖子好疼。<br>
唔，决定每天都拿着强力除草机来刷一刷，让这里成为自己的一小片 `Playground`。

很久之前读过一句话，大概意思是，为什么在各种免费博客平台盛行的时候，你还要自己去购买域名购买服务器然后搭建一套博客平台呢？只因为，这样写出来的东西，就永远打上了自己的域名那样特有的烙印。<br>
典型的个人风格文字，特立独行的思想。
希望我能拥有。

![from Instagram](/content/images/2016/10/13768177_295401884143837_1899942111_n.jpg)


