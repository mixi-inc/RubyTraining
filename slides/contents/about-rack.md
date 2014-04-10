## Rack

---

### これからやること

- Rackの概要
  - WSGIとRack
- 簡単チュートリアル
  - minimal application
  - builder / handler / request / response
  - middleware

---

## WSGIとRack

Rack は WSGI（ウィズギー）

<small>(Web Server Gateway Interface) </small>

からインスパイアされました。

WSGIとは何でしょう？

そしてなぜ生まれたのでしょう？


---

### WSGI に至る背景 (1/3)

> 
- 古き良き時代の実行環境
  - WebアプリといえばCGI
  - Apach / mod_cgi  
- リクエスト数の増加と実行環境の多様化
  - Apache (mod_fastcgi, mod_perl)
  - lighttpd (FastCGI)
  - nginx
- WAFの多様化・乱立
  - WAF: Webアプリのフレームワーク
  - それぞれのアプリでWAFが生まれる
  - そして乱立

---

### WSGI に至る背景 (2/3)

WAFの乱立と実行環境依存、車輪の再発明

![WebFramework x WebServer](http://image.gihyo.co.jp/assets/images/dev/serial/01/perl-hackers-hub/0001/thumb/TH400_001.png)

<small>
参考：[第1回 PSGI/Plack―フレームワークとサーバをつなぐエンジン （1）](http://gihyo.jp/dev/serial/01/perl-hackers-hub/000101)
</small>

---
### WSGI に至る背景 (3/3)

そこで Python では

統一的なインタフェースを **WSGI** と定義し

他言語でもインスパイアされた

<small>
Python: [WSGI](http://www.wsgi.org/),
Perl: [PSGI](http://plackperl.org/),
Ruby: [Rack](http://rack.github.io/) 
</small>

![PSGI](http://image.gihyo.co.jp/assets/images/dev/serial/01/perl-hackers-hub/0001/002.png)

<small>
参考：[第1回 PSGI/Plack―フレームワークとサーバをつなぐエンジン （1）](http://gihyo.jp/dev/serial/01/perl-hackers-hub/000101)
</small>

---

### Rack の場合


> [Ramaze](http://ramaze.net/) /
[Sinatra](http://www.sinatrarb.com/) /
[Padrino](http://www.padrinorb.com/) /
[Rails](http://rubyonrails.org/) /
...

x

> Mongrel /
WEBrick /
FCGI /
CGI /
...

<small>

参考: https://github.com/rack/rack
</small>


---

## 簡単チュートリアル

実際に Rack アプリを作ってみましょう

---

### 準備

```
$ mkdir -p path/to/workdir
$ mkdir rack-tutorial
$ cd rack-tutorial
$ bundle init
$ echo 'gem "rack"' >> Gemfile
$ bundle install
```

---

### はじめに

Rack アプリはシンプル。最低限必要なことは・・・

> 
- callというメソッドを持っていること
- callメソッドの引数としてWebサーバからのリクエストを受けること
- callメソッドは，次の要素を含むレスポンスを返すること
  - ステータスコード
  - レスポンスヘッダ（Hash）
  - レスポンスボディ（Array）

<small>
参考：[第23回 Rackとは何か（1）Rackの生まれた背景](http://gihyo.jp/dev/serial/01/ruby/0023)
</small>

---

### MinimalApp

```
$ vim minimal_app.rb
```

```
class MinimalApp
  def call env
    [ 200, {'Content-Type' => 'text/plain'}, ['Hello, RackApp!'] ]
  end
end
```

--- 

### rackup

Rackアプリを起動するコマンド

<small>
`rackup` コマンドはデフォルトで `config.ru` をみます。内容はこんな感じ
</small>

```
$ vim config.ru
```

```
require './minimal_app'
run MinimalApp.new
```

```
$ bundle exec rackup
```

すると、 localhost:9292 にサーバーが起動します

---