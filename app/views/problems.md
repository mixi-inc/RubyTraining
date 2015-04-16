RubyTraining
============

## はじめに

Sinatra上に構築されたToDoアプリケーションが用意されています。
このアプリケーションに対して、
**(1) APIのバグ修正・リファクタリング、**
**(2) Rackミドルウェアとして切り出し、**
**(3) そのミドルウェアのgem化、**
を行います。

ただし、
初期状態のコードはいい感じに散乱した状態です。
しかし、なぜかしっかりとテストコードも用意されています。
そのテストに沿って修正とリファクタリングを行うことが、課題を得く道筋になるようになっています。

Rubyはそんなに得意じゃないかなという方は、下記のリファレンスやヒントを併せて活用してみてください。

## 便利なリファレンス

- [https://www.google.co.jp/search?q=Ruby](https://www.google.co.jp/search?q=Ruby)
- [今回の研修プレゼン資料](http://mixi-inc.github.io/RubyTraining/slides/)
- [Sinatra Documentation](http://www.sinatrarb.com/documentation.html)
- Relish: RSpec
  - [RSpec Core 3.0](https://relishapp.com/rspec/rspec-core/v/3-0/docs/)
  - [RSpec Expectations 3.0](https://relishapp.com/rspec/rspec-expectations/v/3-0/docs/)
  - [RSpec Mocks 3.0](https://relishapp.com/rspec/rspec-mocks/v/3-0/docs/)
- [Better Specs](http://betterspecs.org/jp/)
- [Bundlerでgemを作る](http://ja.asciicasts.com/episodes/245-new-gem-with-bundler)
- [知って得する！５５のRubyのトリビアな記法](http://melborne.github.io/2013/03/04/ruby-trivias-you-should-know-4/)


簡単な問題
----------

まずは、簡単な問題をやってみましょう。

### 404を表示するページ

`/404` にアクセスすると、Not Foundと表示されます。

しかし、HTTPステータスコードは 302 です（テキストファイルへ redirect しているためです）。
これを Sinatra の `halt` メソッドを使って、正しいHTTPステータスコードを返すよう修正しましょう。

#### ヒント

##### 1.

既存のテストコードは、skip されています。
skipをはずして404を期待するよう動作に修正しましょう。

```
1) app.rb GET /400, 404, 500 given 404 returns 404
     # 問題を解くときに削除してね
     # ./spec/app_spec.rb:145
```

##### 2.

`GET /400` の実装を参考に、
redirectではなく、[Sinatraのhalt](http://www.sinatrarb.com/intro.html#Halting)を使ってみましょう。

### 500を表示するページ

`/500` にアクセスすると 500 と表示されます。

しかし、HTTPステータスコードも 200 を返しています（ヒアドキュメントで直書きされたHTMLを返しているためです）。
正しいHTTPステータスコードを返すように修正しましょう。

今回は、htmlを返すのに [Haml](http://haml.info/) テンプレートを使ってみてください。

#### ヒント

##### 1.

既存のテストコードは、skip されています。
skipをはずして404を期待するよう動作に修正しましょう。

```
2) app.rb GET /400, 404, 500 given 500 returns 500
     # 「500を表示するページ」を解くにはこの行を削除してね
     # ./spec/app_spec.rb:170
```

##### 2.

ヒアドキュメントを使うのではなくhamlテンプレートを使ってみましょう。

[Haml](http://haml.info/) はRuby界隈で主に使われている html markup 方式です。<br>
`app/views/foobar.haml` のように haml ファイルを作成すると、 `haml(:foobar)` で呼び出すことができます。

ex.) `GET /400` では `app/views/bad_request.haml` を利用しています


### リファクタリング (haltを便利メソッドに切り出す)

`/api/*` APIの例外処理として `500` や `400` を返している箇所がほぼ同じ処理をしています。

```ruby
response.status = 500
return nil
```

- これらは単に `halt 500` とまとめてしまいましょう。

また

```ruby
halt 400, {'Content-Type' => 'application/json'}, JSON.dump(message: todo.errors.messages)
```

これらはJSON専用の `json_halt` ヘルパーを作って重複処理をまとめてみましょう

#### ヒント

##### 1.

Sinatraのヘルパーメソッドは以下のように定義することができます。

```ruby
helpers do
  def bar(name)
    "#{name}bar"
  end
end
```


例外を吸収するmiddleware (準備編)
---------------------------------

これから、何ステップかに分けて、例外を吸収するRackのミドルウェアを作成し、 gem にします。
まずは gem に切り出す準備をしましょう :)

### 例外を吸収するmiddlewareを作る (1)

`/error`, `DELETE /api/todos` では、処理が失敗した時に例外処理として 500 を返しています。

- まずはこ resque で行っている処理を特定のメソッドに切り出してみましょう。
- さらに、jsonで `{"message": "unexpected error"}` というレスポンスを返すようにしてください。

#### ヒント

##### 1.

明示的に `nil` を返している箇所で、代わりにjsonを返してあげましょう。

※ 先のリファクタリングでつくった json_halt を利用してみましょう

```ruby
json_halt 500, message: 'unexpected error'
```

##### 2.


```ruby
def do_safety
  yield
resque
  halt 200, '何か起きたけど救われた'
end
```

```ruby
get '/error' do
  do_safety do
    fail
  end
end
```

blockと yield について忘れてしまった場合は、Rubyリファレンスの[yieldの項目](http://docs.ruby-lang.org/ja/2.1.0/doc/spec=2fcall.html#yield)や、
[ブロック付きメソッド呼び出し](http://docs.ruby-lang.org/ja/2.1.0/doc/spec=2fcall.html#block)の項目を参照してみてください。

### 例外を吸収するmiddlewareを作る (2)

(1)で作成したメソッドによって、同じ処理で例外を投げることができるようになりました。ですがまだ、予想外の箇所で例外が投げられた場合にキャッチすることができません。

ToDoアプリ上の全ての例外をキャッチできるように、Rackのミドルウェアを `app/middlewares/server_error.rb` に作成して、(1)で行っている処理を切り出してください。

既に結合テストが `spec/integration/mosscow_integration_spec.rb` に定義されているので、まずはこのテストが動くように変更を加えましょう。

その際、結合テストと `app_spec` で以下のようにpendingされている箇所を忘れずに削除してください。

```ruby
pending('delete this line after you create Rack error catching module')
```

#### ヒント

##### 1.

Rack/Rackミドルウェアについて参考になる記事:

- [第25回　Rackとは何か（3）ミドルウェアのすすめ](http://gihyo.jp/dev/serial/01/ruby/0025)
- [A Quick Introduction to Rack](http://rubylearning.com/blog/a-quick-introduction-to-rack/)
- [Rack Middleware](http://asciicasts.com/episodes/151-rack-middleware)


(1) で作った `do_safety` メソッドでやっていることがミドルウェアの `call` メソッドにそのまま置き換えられそうですね :)

また `Mosscow` 自体は例外を投げるようになってしまうので 500 と返す spec は下記のように置き換えましょう。

```ruby
it 'raises RuntimeError' do
  expect { delete "/api/todos/#{id}" }.to raise_error(RuntimeError)
end
```

##### 2.

結合テストにmiddlewareを組み込むには、切り出したミドルウェアをまず`require`します。
次に、`#app`で定義されているアプリケーションをミドルウェアでDecorateします。

```ruby
require_relative '../../app/middlewares/server_errors'

def app
  @app ||= Rack::ServerErrors.new(Mosscow)
end
```

実際には `config.ru` を編集し、 `app/app.rb` の下記のコメントアウトを外してみましょう

```ruby
# set :show_exceptions, false # uncomment here when you do NOT want to see a backtrace
```


リファクタリング
---------------

gem にするまえに休憩がてらリファクタリングしましょう :)

### Sinatra組み込みのヘルパーメソッドを使う

APIのレスポンスを出力するのに、以下のようにContent-Typeの指定とJSONへの変換を行っている箇所がいくつもあるかと思います。

```ruby
content_type :json
JSON.dump(formatter(todos.as_json, :camel))
```

毎回、`content_type`を指定したり、`JSON.dump`を呼び出すのは非常に面倒なので、Sinatra::JSONというヘルパーを使ってリファクタリングをしましょう。

#### ヒント

##### 1.

sinatra/jsonは、sinatra-contribというgemに含まれています。

##### 2.

下記のようにすると`json`メソッドが使えるようになります。

```ruby
require 'sinatra/json'

class App < Sinatra::Base
  helpers Sinatra::JSON
end
```

### parse_requestの作成

`put '/api/todos/:id'`と`post '/api/todos'`では、request.bodyからJSONを受け取ってparse/エラーハンドリングを行うために、以下のような全く同じ処理を行っています。

```ruby
begin
  params = JSON.parse(request.body.read)
rescue => e
  p e.backtrace unless ENV['RACK_ENV'] == 'test'
  halt 400, { 'Content-Type' => 'application/json' }, JSON.dump(message: 'set valid JSON for request raw body.')
end
```

こういったコピペコードが増えていくと、変更に弱くなってしまいます。`parse_request`というヘルパーメソッドを作成し、処理をこのメソッドにまとめてみましょう。

#### ヒント

##### 1.

Sinatraのヘルパーメソッドの作成方法をもう一度確認してみましょう :)


例外を吸収するmiddleware (gem化編)
--------------------------------

### 例外を吸収するmiddlewareを作る (3)

(2)で例外を自動でキャッチする便利ミドルウェアを作成しましたが、このままでは他のプロジェクトから使うことはできません。
作成したミドルウェアをgemとして切り出し、自分のGithubリポジトリに新しく追加、そちらを参照するようにGemfileを設定してみましょう。

#### ヒント

##### 1.

gemの作り方について参考になる記事:

- [Bundlerでgemを作る](http://ja.asciicasts.com/episodes/245-new-gem-with-bundler)

##### 2.

ミドルウェアをgem化した後に何か更新をかけた場合は、本体側で`bundle update`するのを忘れずに。


camelCase <=> snake_case変換を行うmiddleware (総集編)
-----------------------------------------------------

さて、ここからが本番です！これから、いくつかのステップに分けて、Rackのミドルウェアをもう一つ作り、それをgem化してもらいます。

### camelCase <=> snake_case変換を行うmiddleware (1)

今回は、以下の図のようなrequest.bodyで受け取るJSONのキーをスネークケースに変換し、response.bodyで送り返すJSONのキーをキャメルケースに変換するミドルウェアを作成します。

![](/images/camel_snake.png)

まずは、キャメルケース、スネークケースを相互に変換するために、`to_camel`, `to_snake`というメソッドを作成してみましょう。
(この問題は既にテストが存在します。テストケースが満たされるのであれば、自由に実装/テストの変更を行って構いません。)

#### ヒント

##### 1.

正規表現を使った置換（gsubやsub）と、`downcase`、`upcase`等を組み合わせてみましょう。

##### 2.

実装方法はいくつもありますが、思いつかない場合は、ヘルパーメソッドを作成するか、`String`クラスを拡張してみましょう。

### camelCase <=> snake_case変換を行うmiddleware (2)

(1)で作成した`to_camel`, `to_snake`を利用して、`request.body.read`で受け取るパラメータのキーをスネークケースで受け取り、出力として返すJSONのキーをキャメルケースで返すようにコードを修正しましょう。

例外を吸収するmiddlewareを作る (2)で使用した結合テストにテストケースが既にあるので、下記の変更を加えて、テストが動作するようにしてください。

```ruby
  # Please delete 'broken:true' after you create Rack camel <-> snake converting middleware
  context 'when api called', broken:true do
```

上の行の、`, broken:true`を削除するか、`false`をセットし、ミドルウェアをテストに組み込むと動くようになります。

#### ヒント

##### 1.

再帰を使うと比較的簡単にできます。[JSONの仕様](http://www.json.org/)を確認しておくと、よりやりやすいかもしれません。

##### 2.

今回の場合は、末尾再帰最適化は考えなくて構いません。

### camelCase <=> snake_case変換を行うmiddleware (3)

(1)で行った処理をミドルウェアに切り出してみましょう。テストも同様に移行しましょう。

### camelCase <=> snake_case変換を行うmiddleware (4)

例外を吸収するmiddlewareを作る (3)で行ったように、切り出したミドルウェアをgem化し、自分のリポジトリに公開、それを参照するように変更しましょう。

### camelCase <=> snake_case変換を行うmiddleware (5)

もし、`String`を拡張して`String#to_camel`, `String#to_snake`を実装している場合は、グローバルな名前空間を汚染しているため、あまりお行儀が良いとは言えません。
ruby 2.1.0で正式に追加された[Refinements](http://docs.ruby-lang.org/ja/2.1.0/method/Module/i/refine.html)という機能を使って、書き換えてみましょう。

## おまけ問題

上の問題を全て解き終わってまだ余力がある人は挑戦してみてください。ちょっと難しめです。

`hard/app.rb` に自作のRackミドルウェアを使ったRackアプリケーションがあります。実行してみましょう。

```
$ bundle exec ruby hard/app.rb
```

ポート9292でサーバが起動するので、別のターミナルでシェルを開き、curlを使ってアクセスしてみましょう。

```
$ curl "http://localhost:9292/hoge?id=1"
hello world
$ curl "http://localhost:9292/hoge?id=3"
special!!
```

`hard/app.rb` はURLパラメータで `id=3` が指定されている時に特別なレスポンスを返すアプリケーションです。
また、クエリストリング `id=3` をパースして `{ :id => 3 }` に変換するRackミドルウェアも含んでいます。

`hard/app.rb` はとてもシンプルなアプリケーションですが、実はメモリリークします。

確かめてみましょう。

アプリケーションを起動した後、別のターミナルで 

```
$ bundle exec ruby hard/attack.rb
```

を実行してください。（無限ループでDoSするスクリプトです）

実行しながら アクティビティモニタで ruby プロセスのメモリ使用量を見てみましょう。どんどん使用量が増えていくはずです。（1分放置しておくとプロセスサイズ100MBくらいになります）

### メモリリークの原因

なぜメモリリークが起きるのか説明してください。ノーヒントです :)

### メモリリークが起きないようにする

`SimpleApp`クラスには手を加えずに、`ParamConverter` だけを修正してメモリリークしないようにしてください。
