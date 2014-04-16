# 2014 Ruby研修 実習

実習では、Sinatra上に構築されたToDoアプリケーションのAPIを修正をしつつ、いくつかの機能をRackのミドルウェア化し、gemとして切り出してもらいます。
コードは壊れて散乱した状態になっていますが、テストを予め用意してあるので、基本的には、テストに沿って修正とリファクタリングを行っていくと完成します。

Rubyが得意だという方は、是非、ヒントを見ずに頑張ってみてください。Rubyはそんなに得意じゃないかなという方は、下に便利なリファレンスをまとめているので、ヒントと併せて活用しながら進めてみてください。

## 便利なリファレンス

- [https://www.google.co.jp/search?q=Ruby](https://www.google.co.jp/search?q=Ruby)
- [今回の研修プレゼン資料](http://mixi-inc.github.io/RubyTraining/slides/)
- [Sinatra Documentation](http://www.sinatrarb.com/intro-jp.html)
- [RSpec 2.14 Built-in Matchers](https://www.relishapp.com/rspec/rspec-expectations/v/2-14/docs/built-in-matchers)
- [Better Specs](http://betterspecs.org/jp/)
- [Bundlerでgemを作る](http://ja.asciicasts.com/episodes/245-new-gem-with-bundler)
- [知って得する！５５のRubyのトリビアな記法](http://melborne.github.io/2013/03/04/ruby-trivias-you-should-know-4/)

## 問題

### 404を表示するページ

まずは、簡単な問題を2つほどやってみましょう。

`/404`にアクセスすると、Not Foundと表示されますが、実際にはテキストファイルへredirectしているだけです。これをSinatraの`halt`メソッドを使って、正しいHTTPステータスコードを返すよう修正しましょう。

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

`/500`にアクセスすると、500と表示されますが、実際には、ヒアドキュメントで直書きされたHTMLを返しているだけで、HTTPステータスコードも200を返しています。
正しいHTTPステータスコードを返すように修正しましょう。今回は、htmlを返すのに[Haml](http://haml.info/)テンプレートを使ってみてください。

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

ヒアドキュメントを使うのではなく、`halt`とテンプレートを使うようにしましょう。<br>

[Haml](http://haml.info/)はRuby界隈で主に使われているhtml markup方式です。<br>
`app/views/foobar.haml`のようにhamlファイルを作成すると、`haml(:foobar)`で呼び出すことができます。


### 例外を吸収するmiddlewareを作る (1)

これから、何ステップかに分けて、例外を吸収するRackのミドルウェアを作成します。

`/error`, `DELETE /api/todos`では、処理が失敗した時に例外が投げられていますが、ほとんど同じ処理が重複しています。この処理を特定のメソッドに切り出してみましょう。

さらに、jsonで`{"message": "unexpected error"}`というレスポンスを返すようにしてください。

#### ヒント

##### 1.

一例ですが、`block`, `yield`と`begin-rescue-end`を組み合わせると書きやすいです。
blockとyieldについて忘れてしまった場合は、Rubyリファレンスの[yieldの項目](http://docs.ruby-lang.org/ja/2.1.0/doc/spec=2fcall.html#yield)や、
[ブロック付きメソッド呼び出し](http://docs.ruby-lang.org/ja/2.1.0/doc/spec=2fcall.html#block)の項目を参照してみてください。

##### 2.

明示的に`nil`を返している箇所で、代わりにjsonを返してあげましょう。

```
return nil
```

### 例外を吸収するmiddlewareを作る (2)

(1)で作成したメソッドによって、同じ処理で例外を投げることができるようになりました。ですがまだ、予想外の箇所で例外が投げられた場合にキャッチすることができません。

Sinatra上の全ての例外をキャッチできるように、Rackのミドルウェアを作成して、(1)で行っている処理をすべて切り出してみましょう。

既に結合テストが`spec/integration/mosscow_integration_spec.rb`に定義されているので、まずはこのテストが動くように変更しましょう。

その際、以下のようにpendingされている箇所を忘れずに削除してください。

```ruby
pending('delete this line after you create Rack error catching module')
```

#### ヒント

##### 1.

Rack/middlewareについて:

- [第25回　Rackとは何か（3）ミドルウェアのすすめ](http://gihyo.jp/dev/serial/01/ruby/0025)
- [Rack Middleware](http://asciicasts.com/episodes/151-rack-middleware)
- [A Quick Introduction to Rack](http://rubylearning.com/blog/a-quick-introduction-to-rack/)

##### 2.

結合テストにmiddlewareを組み込むには、切り出したミドルウェアをまず`require`します。
次に、`#app`で定義されているアプリケーションをミドルウェアでDecorateします。

```ruby
require 'rack/server_errors'

def app
    @app ||= Rack::ServerErrors.new(Mosscow)
end
```

### 例外を吸収するmiddlewareを作る (3)

(2)で例外を自動でキャッチする便利ミドルウェアを作成しましたが、このままでは他のプロジェクトから使うことはできません。
作成したミドルウェアをgemとして切り出し、自分のGithubリポジトリに新しく追加、そちらを参照するようにGemfileを設定してみましょう。

#### ヒント

##### 1.

gemの作り方:

- [Bundlerでgemを作る](http://ja.asciicasts.com/episodes/245-new-gem-with-bundler)
- [gemパッケージの作り方メモ。](http://yukihir0.hatenablog.jp/entry/20130107/1357557569)の1-9まで

##### 2.

ミドルウェアをgem化した後に何か更新をかけた場合は、本体側で`bundle update`するのを忘れずに :)


### 小休憩(1) リファクタリング (haltを便利メソッドに切り出す)

ここからしばらく、小休憩です。簡単な問題をいくつかやってみましょう! :)

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

Sinatraのヘルパーメソッドは以下のように定義することができます。

```ruby
helpers do
  def bar(name)
    "#{name}bar"
  end
end
```

### 小休憩(2) リファクタリング (Sinatra組み込みのヘルパーメソッドを使う)

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

### 小休憩(3) リファクタリング (parse_requestの作成)

`put '/api/todos/:id'`と`post '/api/todos'`では、request.bodyからJSONを受け取ってparse/エラーハンドリングを行うために、以下のような全く同じ処理を行っています。

```ruby
begin
  params = JSON.parse(request.body.read)
rescue => e
  p e.backtrace unless ENV['RACK_ENV'] == 'test'
  halt 400, { 'Content-Type' => 'application/json' }, JSON.dump(message: 'set valid JSON for request raw body.')
end
```

こういったコピペコードが増えていくと、変更に弱くなってしまうので、`parse_request`というヘルパーメソッドを作成し、処理をこのメソッドにまとめてみましょう。

#### ヒント

##### 1.

Sinatraのヘルパーメソッドの作成方法は、小休憩(1)でやったと思うので、そこをもう一度確認してみましょう。

### camelCase <=> snake_case変換を行うmiddlewareを作る (1)

さて、ここからが本番です！これから、いくつかのステップに分けて、Rackのミドルウェアをもう一つ作って、gem化してもらいます。

今回作成するミドルウェアでは、request.bodyで受け取るJSONのキーをスネークケースに変換し、response.bodyで送り返すJSONのキーをキャメルケースに変換します。

![](/images/camel_snake.png)

まずは、キャメルケース、スネークケースを相互に変換するために、`to_camel`, `to_snake`というメソッドを作成してください。
(テストケースが満たされるのであれば、自由に実装/テストの変更を行って構いません。)

#### ヒント

##### 1.

正規表現を使った置換（gsubやsub）と、`downcase`、`upcase`等を組み合わせてみましょう。

##### 2.

いくつも実装は方法はありますが、思いつかない場合は、ヘルパーメソッドを作成するか、`String`クラスを拡張してみましょう。

### camelCase <=> snake_case変換を行うmiddlewareを作る (2)

(1)で作成した`to_camel`, `to_snake`を利用して、`request.body.read`で受け取るパラメータのキーをスネークケースで受け取り、出力として返すJSONのキーをキャメルケースで返すようにコードを修正しましょう。

例外を吸収するmiddlewareを作る (2)で使用した結合テストにテストケースが既にあるので、下記の変更を加えて、テストが動作するようにしてください。

```ruby
  # Please delete 'broken:true' after you create Rack camel <-> snake converting middleware
  context 'when api called', broken:true do
```

上の行の、`, broken:true`を削除するか、`false`をセットし、ミドルウェアをテストに組み込むと動くようになります。

#### ヒント

##### 1.

再帰を使うと比較的簡単にできます。[JSONの仕様](http://www.json.org/)を確認するとやりやすいかもしれません。

##### 2.

今回の場合は、末尾再帰最適化は考えなくて構いません。

### camelCase <=> snake_case変換を行うmiddlewareを作る (3)

(1)で行った処理をミドルウェアに切り出してみましょう。テストも同様に移行しましょう。

### camelCase <=> snake_case変換を行うmiddlewareを作る (4)

例外を吸収するmiddlewareを作る (3)で行ったように、切り出したミドルウェアをgem化し、自分のリポジトリに公開、それを参照するように変更しましょう。

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
