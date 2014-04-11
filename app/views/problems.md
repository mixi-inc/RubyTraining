# 2014 Ruby 研修

## 便利なリファレンス

- [今回の研修プレゼン資料](http://junsumida.github.io/mosscow/slides/)
- [Sinatra Documentation](http://www.sinatrarb.com/intro-jp.html)
- [RSpec 2.14 Built-in Matchers](https://www.relishapp.com/rspec/rspec-expectations/v/2-14/docs/built-in-matchers)
- [Better Specs](http://betterspecs.org/jp/)

## 問題

### 404を表示するページ

`/404`にアクセスすると、Not Foundと表示されますが、実際には静的なhtmlへredirectしているだけです。これをSinatraのhaltを使って、正しいHTTP statusを返すよう修正しましょう。

#### ヒント

##### 1.

既存のテストコードは、HTTPステータスコード 302を期待していますが、404を期待するように修正しましょう。

```ruby
context 'given 404' do
  it 'returns 302' do
    get '/302'
    last_response.status = 302
  end
end
```

##### 2.

redirectではなく、[Sinatraのhalt](http://www.sinatrarb.com/intro.html#Halting)を使ってみましょう。

### 500を表示するページ

`/500`にアクセスすると、500と表示されますが、コード中では、ヒアドキュメントで直書きされたHTMLを返しているだけで、HTTPステータスコード 200を返しています。
これも正しいHTTP statusで、テンプレートを使って返すように修正しましょう。

#### ヒント

##### 1.

既存のテストコードは、HTTPステータスコード 200を期待していますが、500を期待するように修正しましょう。

```ruby
context 'given 500' do
  it 'returns 200' do
    get '/500'
    last_response.status = 200;
  end
end
```

##### 2.

ヒアドキュメントを使うのではなく、`halt`とテンプレートを使うようにしましょう。
hamlを使う場合の話ですが、`app/views/foobar.haml`のようにhamlファイルを作成すると、`haml(:foobar)`で呼び出すことができます。


### 例外を吸収するmiddlewareを作る (1)

`/error`, `DELETE /api/todos`では、処理が失敗した時に例外が投げられていますが、ほとんど同じ処理が重複しています。この処理を特定のメソッドに切り出してみましょう。

#### ヒント

##### 1.

blockとyieldをつかうと綺麗にかけます。<br>
忘れてしまった時は、CodeAcademyの15講を参照してみてください :)

### 例外を吸収するmiddlewareを作る (2)

(1)で作成したメソッドによって、同じ処理で例外を投げることができるようになりましたが、まだ予想外の箇所で例外が投げられた場合にそれをキャッチすることはできません。<br>
Sinatra上の全ての例外をキャッチできるように、(1)で行っている処理をRackのmiddlewareを作成して、処理をすべてそちらに切り出してみましょう。

#### ヒント

##### 1.

Rack/middlewareについて:

- [第25回　Rackとは何か（3）ミドルウェアのすすめ](http://gihyo.jp/dev/serial/01/ruby/0025)
- [Rack Middleware](http://asciicasts.com/episodes/151-rack-middleware)
- [A Quick Introduction to Rack](http://rubylearning.com/blog/a-quick-introduction-to-rack/)

### 例外を吸収するmiddlewareを作る (3)

(2)で例外を自動でキャッチする便利モジュールを作成しましたが、このままでは他のプロジェクトから使うことができません。
作成したmiddlewareをgemとして切り出し、自分のリポジトリに新しく追加し、そちらを参照するようにGemfileを設定しましょう。

#### ヒント

##### 1.

gemの作り方:

- [Bundlerでgemを作る](http://ja.asciicasts.com/episodes/245-new-gem-with-bundler)
- [gemパッケージの作り方メモ。](http://yukihir0.hatenablog.jp/entry/20130107/1357557569)の1-9まで

### 小休憩(1) リファクタリング (haltを便利メソッドに切り出す)

ここからしばらく、小休憩です。簡単な問題をやってみましょう :)

app.rb内に以下のような箇所がたくさんあります。

```ruby
response.status = 500
content_type :json
JSON.dump({message: 'unexpected error'})
```

これは `halt` を使ってもっと短く書くことができます。例えば、app.rb にも以下のように記述されている箇所があります。

```ruby
halt 400, {'Content-Type' => 'application/json'}, JSON.dump(message: todo.errors.messages)
```

まずは `response.status = ...` となっている箇所を `halt` で書き直してください。

次に、毎回 `JSON.dump` とか `content_type :json` と書くのは面倒なので、JSON専用の `halt`, `json_halt` ヘルパーを作ってみましょう。

#### ヒント

##### 1.

Sinatraのhelper methodは以下のように定義することができます。

```ruby
helpers do
  def bar(name)
    "#{name}bar"
  end
end
```

### 小休憩(2) リファクタリング (Sinatra組み込みのhelperメソッドを使う)

APIのレスポンスを出力するのに、以下のようにcontent-typeとJSONへの変換を行っている箇所がいくつもあるかと思います。

```ruby
content_type :json
JSON.dump(formatter(todos.as_json, :camel))
```

毎回、content_typeを指定したり、JSON.dumpを呼び出すのは非常に面倒なので、Sinatra::JSONというHelperを使ってリファクタリングをしましょう。

#### ヒント

##### 1.

sinatra/jsonは、sinatra-contribというgemに含まれています。

##### 2.

下記のようにすると`json`メソッドが使えるようになります。

```ruby
require 'sinatra/json' # 読み込み

class App < Sinatra::Base
  helpers Sinatra::JSON # 使えるように
end
```

### 小休憩(3) リファクタリング (parse_requestの作成)

`put '/api/todos/:id'`と`post '/api/todos'`では、request.bodyからJSONを受け取って解釈/エラーハンドリングを行うために、以下のような全く同じ処理があります。

```ruby
begin
  params = JSON.parse(request.body.read)
rescue => e
  p e.backtrace unless ENV['RACK_ENV'] == 'test'
  halt 400, { 'Content-Type' => 'application/json' }, JSON.dump(message: 'set valid JSON for request raw body.')
end
```

こういったコピペコードが増えていくと、変更に弱くなるので、`parse_request`というhelperメソッドを作成し、処理をこのメソッドにまとめてみましょう。

#### ヒント

##### 1.

Sinatraのhelperメソッドの作成方法は、小休憩(1)でやったと思うので、そこをもう一度みてみましょう。

### camelCase <=> snake_case変換を行うmiddlewareを作る (1)

これから、いくつかのステップに分けて、middlewareをもう一つ作ります。

今度は何をしたいかというと、JSONのキーは全てキャメルケースで、rubyのハッシュのキーは全てスネークケースで扱えるようにします。

まずは、キャメルケース、スネークケースの変換が行える必要があるので、`to_camel`, `to_snake`という変換のためのメソッドを作成してください。(今回は、既にテストケースがあるので、テストケースが満たされるのであれば、実装方法は問いません。)

#### ヒント

##### 1.

正規表現で頑張ってください^^

##### 2.

実装にはいくつも方法があるかとおもいますが、今回は、helperメソッドを作成するか、`String`クラスを拡張してみましょう。

### camelCase <=> snake_case変換を行うmiddlewareを作る (2)

(1)で作成した`#to_camel`, `#to_snake`を利用して、`request.body.read`で受け取るパラメータのキーをスネークケースで受け取り、出力として返すJSONのキーをキャメルケースで返すようにコードを修正しましょう:。

既に`/spec/integration/mosscow_integration_spec.rb`という名前の結合テストがあるので、作成したミドルウェアに合わせて、テストが動作するようにしてください。

```ruby
  # please get rid of this 'broken:true' after you create Rack camel <-> snake converting middleware
  context 'when api called', broken:true do
```

上の行の、`, broken:true`を削除するか、`false`をセットすると、テストが動くようになります。

#### ヒント

##### 1.

再帰を使うと、比較的簡単に書くことができます。

### camelCase <=> snake_case変換を行うmiddlewareを作る (3)

(1)で行った処理をmiddlewareに切り出してみましょう。テストも同様に移行しましょう。

### camelCase <=> snake_case変換を行うmiddlewareを作る (4)

例外を吸収するmiddlewareを作る (3)でやったように、切り出したmiddlewareをgem化し、自分のリポジトリに公開、それを参照するように変更しましょう。

### camelCase <=> snake_case変換を行うmiddlewareを作る (5)

もし、`String`を拡張して`String#to_camel`, `String#to_snake`を実装している場合は、グローバルな名前空間を汚染しているため、あまりお行儀が良いとは言えません。
ruby 2.1.0にある[Refinements](http://qiita.com/yustoris/items/77fd309178dcdd13b5cd)という機能を使って、グローバルな名前空間を汚染しないように書き換えてみましょう。

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
