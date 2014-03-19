Moss Cow
=====================
[![Build Status](https://travis-ci.org/junsumida/mosscow.png?branch=master)](https://travis-ci.org/junsumida/mosscow)
[![Code Climate](https://codeclimate.com/github/junsumida/mosscow.png)](https://codeclimate.com/github/junsumida/mosscow)
[![Coverage Status](https://coveralls.io/repos/junsumida/mosscow/badge.png)](https://coveralls.io/r/junsumida/mosscow)

![](http://1funny.com/wp-content/uploads/2012/05/moscow.jpg)

# 開発のはじめ方

## 環境のセットアップ
```
$ git clone git@github.com:junsumida/mosscow.git
$ cd mosscow
$ bundle install
```

環境のセットアップが終わったら、まずテストを実行して通ることを確認してください。

```
$ bundle exec rake
…
Finished in 0.13644 seconds
17 examples, 0 failures, 1 pending
$
```

## データベースのセットアップ
このプロジェクトではローカルのSQLiteを使用します。以下のコマンドで開発用のDBにサンプルデータを読み込んでください。

```
$ bundle exec rake db:migrate
$ bundle exec rake db:seed
```

## 開発用サーバの起動
以下のコマンドでサーバを起動し、http://localhost:9292/ にアクセスしてみてください。

```
$ bundle exec rackup -p 9292
```
