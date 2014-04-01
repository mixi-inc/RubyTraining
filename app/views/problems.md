# 2014 Ruby 研修

## 便利なリファレンス

- [Sinatra Documentation](http://www.sinatrarb.com/intro-jp.html)
- [RSpec 2.14 Built-in Matchers](https://www.relishapp.com/rspec/rspec-expectations/v/2-14/docs/built-in-matchers)
- [Better Specs](http://betterspecs.org/jp/)

## 問題

### 404を表示するページ

`/404`にアクセスすると、Not Foundと表示されますが、実際には静的なhtmlへredirectしているだけです。これを修正してください。

#### ヒント

##### 1.

既存のテストコードは、HTTPステータスコード 302を期待していますが、404を期待するように修正してください。

```ruby
context 'given 404' do
  it 'returns 302' do
    get '/302'
    last_response.status = 302
  end
end
```

##### 2.

redirectではなく、Sinatraの強制終了を行うようにしてください。

### 500を表示するページ

`/500`にアクセスすると、500と表示されますがコード中では、ヒアドキュメントで直書きされたHTMLを返しているだけで、HTTPステータスコード 200を返しています。これを修正してください。

#### ヒント

##### 1.

既存のテストコードは、HTTPステータスコード 200を期待していますが、500を期待するように修正してください。

```ruby
context 'given 500' do
  it 'returns 200' do
    get '/500'
    last_response.status = 200;
  end
end
```

##### 2.

ヒアドキュメントを使うのではなく、テンプレートを使うようにしてください。


### 例外を吸収するmiddlewareを作る (1)

`/error`, `DELETE /api/todos`では、処理が失敗した時に例外が投げられていますが、ほとんど同じ処理が重複しています。この処理を特定のメソッドに切り出してください。

#### ヒント

##### 1.

blockとyieldをつかうと綺麗にかけます。<br>
忘れちゃった時は、CodeAcademyの15講をみてね^^

### 例外を吸収するmiddlewareを作る (2)

　(1)で作成したメソッドによって、同じ処理で例外を投げることができるようになりましたが、まだ予想外の箇所で例外が投げられた場合にそれをキャッチすることはできません。<br>
　Sinatra上の全ての例外をキャッチできるように、(1)で行っている処理をRackのmiddlewareとして書き換えてください。

#### ヒント

##### 1.

Rack/middlewareについて:

- [第25回　Rackとは何か（3）ミドルウェアのすすめ](http://gihyo.jp/dev/serial/01/ruby/0025)
- [Rack Middleware](http://asciicasts.com/episodes/151-rack-middleware)
- [A Quick Introduction to Rack](http://rubylearning.com/blog/a-quick-introduction-to-rack/)

### 例外を吸収するmiddlewareを作る (3)

　(2)で例外を自動でキャッチする便利モジュールを作成しましたが、このままでは他のプロジェクトから使うことができません。
　作成したmiddlewareをgemとして切り出し、自分のリポジトリに新しく追加し、Gemfileの参照先をそちらに向けてください。

#### ヒント

##### 1.

gemの作り方:

- [Bundlerでgemを作る](http://ja.asciicasts.com/episodes/245-new-gem-with-bundler)
- [gemパッケージの作り方メモ。](http://yukihir0.hatenablog.jp/entry/20130107/1357557569)の1-9まで

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
$ bundle exec ruby app/attack.rb
```

を実行してください。（無限ループでDoSするスクリプトです）

実行しながら アクティビティモニタで ruby プロセスのメモリ使用量を見てみましょう。どんどん使用量が増えていくはずです。（1分放置しておくとプロセスサイズ100MBくらいになります）

### メモリリークの原因

なぜメモリリークが起きるのか説明してください。ノーヒントです :)

### メモリリークが起きないようにする

`SimpleApp`クラスには手を加えずに、`ParamConverter` だけを修正してメモリリークしないようにしてください。