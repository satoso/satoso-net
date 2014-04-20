---
layout: post
title:  ".htaccessの指定によって意図しないリダイレクトが発生した件"
---

ドキュメントの実ファイルをそっくり別のディレクトリに入れておきたい場合がある。例えば`/index.html`へのアクセスで`/somedir/index.html`を返したい。このように`/`へのアクセスを`/somedir/`へ向ける場合，`.htaccess`にこんな感じで書く。

```apache
# リクエストしたファイルが存在せず，かつディレクトリも存在しない場合，rewriteする
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^(.*)$ somedir/$1 [L,QSA]
```

ところがこれをやったらサーバのログにエラーメッセージがたくさん出て，対処方法が分からずずいぶんとハマった。こういうのが大量に出る。

```
[xxx xxx xx xx:xx:xx 2014] [error] [client xx.xxx.xx.xx] Request exceeded the limit of 10 internal redirects due to probable configuration error. Use 'LimitInternalRecursion' to increase the limit if necessary. Use 'LogLevel debug' to get a backtrace.
```

結論から言うと，この原因は<em>`favicon.ico`と`robots.txt`がないこと</em>だった。そもそも上の記述は，`/`にも`/somedir/`にも存在しないファイルに対してアクセスがあった場合，`somedir/somedir/somedir/...`と，見つかるまでrewriteし続ける（はず。ログレベルがいじれなくて詳細が分からなかったが）。ブラウザでの閲覧で`favicon.ico`に，検索エンジンのクロールで`robots.txt`にそれぞれアクセスするので，ファイルがないからリダイレクトの上限に達するまでrewriteされてしまったというわけ。この2ファイルを置いたら解決。

当然ながら，これは`favicon.ico`と`robots.txt`に限った話ではなく，存在しないファイルにアクセスされた場合にはエラーメッセージがログに出る。
