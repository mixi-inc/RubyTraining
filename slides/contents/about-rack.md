## Rack

---

### ここでやること

- Rackの概要
  - WSGIとRack
- 簡単チュートリアル
  - MinimalApp
  - config.ru / Rack::Builder
  - Middleware
  - 補足

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
  - Apache / mod_cgi  
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
Ruby: [Rack](http://rack.github.io/),
Perl: [PSGI](http://plackperl.org/)
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

<small>
参考サイト

[第23回 Rackとは何か（1）Rackの生まれた背景](http://gihyo.jp/dev/serial/01/ruby/0023)

[第24回 Rackとは何か（2）Rackの使い方](http://gihyo.jp/dev/serial/01/ruby/0024)

[第24回 Rackとは何か（3）ミドルウェアのすすめ](http://gihyo.jp/dev/serial/01/ruby/0025)
</small>

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

```ruby
class MinimalApp
  def call env # リクエスト(env)は Hash
    [                                  # レスポンスはArray
      200,                             # status code
      {'Content-Type' => 'text/html'}, # response headers
      ['hello world!']                 # response body
    ]
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

### `rackup` で何をやってるのか？

> [Rack::Builder](https://github.com/rack/rack/blob/master/lib/rack/builder.rb)
> によって config.ru からアプリをビルドして
> [Rack::Server](https://github.com/rack/rack/blob/master/lib/rack/server.rb)
> でサーバーを起動している


<small>
オプションはdefaultが指定されている

例えば handler は Rack::Handler::WEBrick で Port は 9292 等
</small>

---

### つまりこうも書ける

```ruby
# minimal_app.rb
require 'rack'
class MinimalApp
  def call env
    [ 200, {'Content-Type' => 'text/html'}, ['hello world!'] ]
  end
end
Rack::Handler::WEBrick.run MinimalApp.new, :Port => 9292
```

```
$ bundle exec ruby minimal_app.rb
```

さっきと同じはず

---

### お気づきの方もいらっしゃいますね？

<small>
[Proc](http://docs.ruby-lang.org/ja/2.1.0/class/Proc.html)クラスのインスタンスも `call` があるので

さらにこうも書けます
</small>

```ruby
# minimal_app.rb
require 'rack'
app = Proc.new {|env|
  [ 200, {'Content-Type' => 'text/html'}, ['hello world!'] ]
}
Rack::Handler::WEBrick.run app, :Port => 9292
```
or
```ruby
# config.ru
run lambda {|e| [200, {"Content-Type"=>"text/html"}, ["Hi!"]] }
```

---

NOTE : config.ru の役割

<small>

`config.ru` には

Webサーバーに依存するのコード（設定等）を書く

アプリケーション側には、サーバー依存のコードは書かないようにしてる
</small>

<small>
参考：[第24回 Rackとは何か（2）Rackの使い方](http://gihyo.jp/dev/serial/01/ruby/0024)


とりあえず、コードで理解していきましょう :)
</small>


---

### 例えば

> エンドポイントごとにアプリを分けるようハンドリングしたい

---

### `config.ru`

```ruby
require './minimal_app'

app = Rack::Builder.new do
  map "/api" do
    run lambda {|e| [200, {'Content-Type'=>'text/html'}, ['api!']] }
  end
  map "/" do
    run MinimalApp.new
  end
end

run app
```

こうすればアプリはアプリ側のコードに専念できますよね

---

### Middleware

---

> ### ミドルウェアとは
> 「別なアプリケーションをラップして，リクエストやレスポンスを加工したり，処理を切り換えたりするRackアプリケーション」です

<small>
[第25回 Rackとは何か（3）ミドルウェアのすすめ](http://gihyo.jp/dev/serial/01/ruby/0025)
</small>

---

> ### 例えば
> `Content-Type:application/json` ではない
> 
> `/api` へのリクエスト
> 
>  400 で返したい

↓

それミドルウェアで

---

### ミドルウェアの作り方（基本）

```ruby
# api_request_filter.rb
class APIRequestFilter
  def initialize app
    @app = app # app 受け取る
  end
  def call env # Rackアプリの仕様通りで
    @app.call(env)
  end
end
```

想像つきやすいですね！

> APIRequestFilter ->
> NextMiddleware ->
> NextApp -> ... 

という風にリクエストが処理されます


---

### ミドルウェアの使い方

```ruby
MiddlewareA.new(
  MiddlewareB.new(
    HogeApp.new
  )
)
```

という感じでRackアプリを作るやり方もできます

しかし、通常やりません :(

---

### 通常は

run する前に **use** するだけでOKです :)

---

### Example (config.ru)

```
require './minimal_app'
require './api_request_filter'

app = Rack::Builder.new do
  map "/api" do
    use APIRequestFilter
    run lambda {|e| [200, {'Content-Type'=>'text/html'}, ['api!']] }
  end
  map "/" do
    run MinimalApp.new
  end
end

run app
```

---

### Example (api_request_filter.rb)

`api_request_flter.rb`

```ruby
require 'rack/request'
require 'rack/response'

class APIRequestFilter
  def initialize app
    @app = app
  end
  
  def call env
    request = Rack::Request.new(env)
    raise unless request.content_type == 'application/json'
    @app.call(env)
  rescue
    response = Rack::Response.new {|r|
      r.status = 400
      r["Content-Type"] = "text/html"
      r.write "Bad Request"
    }
    response.finish
  end
end
```

---

### Example （実行例)

```
$ curl localhost:9292/api -i
HTTP/1.1 400 Bad Request
Content-Type: text/html
Content-Length: 11
Server: WEBrick/1.3.1 (Ruby/2.1.0/2013-12-25)
Date: Fri, 11 Apr 2014 04:10:18 GMT
Connection: Keep-Alive

Bad Request
```
```
$ curl localhost:9292/api -H 'Content-Type:application/json' -i
HTTP/1.1 200 OK
Content-Type: text/html
Transfer-Encoding: chunked
Server: WEBrick/1.3.1 (Ruby/2.1.0/2013-12-25)
Date: Fri, 11 Apr 2014 04:11:13 GMT
Content-Length: 14
Connection: Keep-Alive

api!
```

---

### 補足

---

### [Rack::Request](http://rack.rubyforge.org/doc/classes/Rack/Request.html) / [Rack::Response](http://rack.rubyforge.org/doc/classes/Rack/Response.html)


> リクエストの内容を env から取得したり
> 
> レスポンスの内容を配列で作る

↑

この辺うまいことやってくれる

---

### [Rack::Utils](http://rack.rubyforge.org/doc/classes/Rack/Utils.html)

> クエリーストリングをパース
> 
> URLのエスケープ/アンエスケープ
> 
> htmlのエスケープ

↑

この辺うまいことやってくれる

---

### 便利なミドルウェア

これらは標準添付

> **Rack::MethodOverride** : DELETE/PUTをPOSTと扱いたい場合など
> 
> **Rack::Static** : 静的ファイルの配信
> 
> **Rack::Deflater** : レスポンスをgzip圧縮
> 
> **Rack::Lint** : リクエスト/レスポンスがRackの仕様に沿っているかをチェック
> 
> **Rack::ShowExceptions** : 例外の内容を整形
> 
> **Rack::Reloader** : 変更をリロード
> 
> **Rack::Session** : Basic認証/Cookieセッション等

---

### ここでやったこと

- Rackの概要
  - WSGIとRack
- 簡単チュートリアル
  - MinimalApp
  - config.ru / Rack::Builder
  - Middleware
  - 補足
  
---

## Rack

おわり