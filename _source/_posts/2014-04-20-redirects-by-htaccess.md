---
title:  ".htaccess の指定によって無限リダイレクトが発生した件"
description: ".htaccess でリダイレクトさせる際には，存在しないファイルへのアクセスを考慮する必要がある。"
---

ドキュメントの実ファイルをそっくり別のディレクトリに入れておきたい場合がある。例えば `/` へのアクセスを `/somedir/` へ向ける（ `/index.html` へのアクセスで `/somedir/index.html` を返す）場合， `.htaccess` にこんな感じで書く。

~~~apache
#.htaccess
# リクエストしたファイルが存在せず，かつディレクトリも存在しない場合，rewriteする
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^(.*)$ /somedir/$1 [L,QSA]
~~~

ところがこれをやったらサーバのログにエラーメッセージがたくさん出て，対処方法が分からずずいぶんとハマった。こういうのが大量に出る。

~~~
[xxx xxx xx xx:xx:xx 2014] [error] [client xx.xxx.xx.xx] Request exceeded the limit of 10 internal redirects due to probable configuration error. Use 'LimitInternalRecursion' to increase the limit if necessary. Use 'LogLevel debug' to get a backtrace.
~~~

結論から言うと，直接の原因は <em>`favicon.ico` と `robots.txt` がないこと</em>だった。そもそも上の記述は， `/` にも `/somedir/` にも存在しないファイルに対してアクセスがあった場合， `/somedir/somedir/somedir/...` と，見つかるまで rewrite し続ける（はず。ログレベルがいじれなくて詳細が分からなかったが）。ブラウザでの閲覧で `favicon.ico` に，検索エンジンのクロールで `robots.txt` にそれぞれアクセスするので，ファイルがないからリダイレクトの上限に達するまでrewriteされてしまったというわけ。

当然ながらこれは `favicon.ico` と `robots.txt` に限った話ではなく，存在しないファイルにアクセスされた場合には同様の結果になる。根本的な解決策としては <em>`RewriteCond %{REQUEST_URI} !^/somedir` という1行を追加して， `/somedir` で始まるURIに対してはもう書き換えしないようにする。</em>

~~~apache
#.htaccess
# リクエストしたファイルが存在せず，かつディレクトリも存在しない場合，rewriteする
RewriteCond %{REQUEST_URI} !^/somedir
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^(.*)$ /somedir/$1 [L,QSA]
~~~

