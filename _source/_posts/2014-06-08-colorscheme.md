---
title:  "目に優しい系 colorscheme の問題点"
description: "目に優しい低彩度・低コントラストの colorscheme について。"
---

Vim や Terminal の colorscheme では， Solarized を筆頭に，目に優しい系の配色が人気だ。確かに低彩度・低コントラストの色の方が目の疲れが軽減されるのだが，単純にそういう colorscheme を使うだけで問題が解決するわけではない。

- 細身のフォントでは色が見分けられない
    - 目に優しい系 colorscheme はどぎつい色を避けているが，そもそもフォントが細身だと微妙な色の違いが分かりにくい。そういう場合は適当に彩度の高いものを選ぶのがよい。私はフォントは Ricty を使っていて，これもそんなに太い部類ではないので淡すぎる色合いは避けている。私の今の気に入りは [hybrid](https://github.com/w0ng/vim-hybrid) である。
- 特定のアプリケーションだけ目に優しくても仕方がない
    - 普通は Vim や Terminal だけを使っているわけではないので，例えばブラウザの真っ白い画面と行ったり来たりすることも目の負担になる。好みにもよるが，ディスプレイ自体の輝度やコントラストを調節した方がよい場合がある。そして colorscheme はそれなりにコントラストの高いものを使う。