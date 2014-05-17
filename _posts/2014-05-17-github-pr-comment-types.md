---
layout: post
title:  "GitHubのpull requestに対するコメントの付け方は4種類"
---

GitHubのissue(PR)に対するコメントの付け方がいろいろあってよく分からなくなったので実験してみた。4種類ある。

- pull requestに対するコメント:<br>`<username> commented`
- commitに対するコメント:<br>`<username> commented on <commit hash>`
- commitの特定の行に対するコメント:<br>`<username> commented on <commit hash> <filename>:L<line number>`
- filesの特定の行に対するコメント:<br>`<username> commented on the diff`

すべてが入ったサンプルはこちら。

- [https://github.com/satoso/pullreq/pull/2](https://github.com/satoso/pullreq/pull/2)


