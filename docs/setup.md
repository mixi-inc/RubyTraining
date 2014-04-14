# 開発のはじめかた

下記の手順を参考に TODO アプリを起動して下さい。

- 起動後、実習用の問題ページが下記URLで確認できます。
- [http://localhost:9292/problems](http://localhost:9292/problems) 

## 環境のセットアップ

### コードの fork / clone

このリポジトリをローカルに git clone してください。

```
$ git clone https://github.com/mixi-inc/RubyTraining.git
$ cd RubyTraining
```

※ 開発対象は `problems` ブランチです

※ もし Travis CI / Code Climate / Coveralls を利用したいのであれば、fork してから clone して下さい。

### bundle install

このプロジェクトでは [bundler](http://bundler.io/) を利用してライブラリを管理しています。（最近のほとんどのRubyアプリケーションは bundler を使って管理されています）

まずは bundler を利用してプロジェクトが依存しているライブラリをインストールします。

```
$ gem install bundler  # 必要に応じて
$ bundle install
```

このプロジェクトでは ruby-2.1.0 のバージョンを指定しているので、それ以外のRubyでは bundle install できません。
ruby-2.1.0 が入っていない場合は rbenv を使ってインストールしてください。

### テスト実行

bundle install が終わったら、テストを実行して通ることを確認してください。
このプロジェクトでは `rake` コマンドで全てのテストを実行できます。

```
$ bundle exec rake
…
Finished in 0.13644 seconds
17 examples, 0 failures, 1 pending
$
```

## データベースのセットアップ

このプロジェクトではデータベースとしてSQLiteを使用しています。以下のコマンドで開発用のDBにサンプルデータを読み込んでください。

```
$ bundle exec rake db:migrate
$ bundle exec rake db:seed
```

## 開発用サーバの起動
以下のコマンドでサーバを起動し、[http://localhost:9292/](http://localhost:9292/) にアクセスしてみてください。

```
$ bundle exec rackup -p 9292
```

## サンプルアプリケーションの確認
サンプルアプリケーションのシンプルなTODOアプリが [http://localhost:9292/todos/index.html](http://localhost:9292/todos/index.html) で動いています。

TODOの閲覧・新規作成・削除が正しく行えること、これらを行ってもコンソールにエラーログが出ていないことを確認してください。


## おまけ

### rubocop (コーディング規約適用ツール)

[rubocop](https://github.com/bbatsov/rubocop)というコーディング規約の適用ツールがあります。
(日本語だと、[こちらのQiitaの記事](http://qiita.com/yaotti/items/4f69a145a22f9c8f8333)が参考になります。)

コマンドラインから直接実行する場合は、

```
# チェックのみ
rubocop

# 自動訂正付き
rubocop -a
```

のようにすると実行可能です。

デフォルトではオフにしていますが、`pull-request`中で使いたい場合は、
config.ruの中の以下のコメントアウトを解除してください。

```ruby
  ENV['RACK_ENV'] ||= 'test'
  # sh 'rubocop'
  sh 'rspec'
```

### Mosscow is Moss Cow

![moss cow](img/mosscow.png)

different from moscow
