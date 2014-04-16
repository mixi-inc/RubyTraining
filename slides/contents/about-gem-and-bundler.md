## gem / bundler

---

### ここでやること

- gemの概要
- bundlerの概要

---

## RubyGems

> Rubyには、幅広い3rd partyのライブラリが提供されています。それらの多くは [RubyGems](https://rubygems.org/) にてパッケージ管理されており、それらは **gem** と呼ばれています。

<small>

Linuxの各ディストリビューションにおいて

`apt` や `yum` コマンドを利用してパッケージをインストールできるように、

Rubyにおいても `gem` コマンドで Ruby のライブラリを利用することができます。

もちろん gem の依存関係に応じて芋づる式にインストールとかできます。
</small>

---

### gem コマンド

```
$ gem install rspec    # gem のインストール
$ gem uninstall rspec  # gem のアンインストール
$ gem list             # インストール済みの gem 表示
$ gem search rspec     # gem の検索
$ gem server           # インストール済みの gem の doc を localhost で閲覧
$ gem help
```

<small>
検索時はだいたい下記とかから見たり

https://rubygems.org/

https://www.ruby-toolbox.com/
</small>

---

### 補足


インストール時のドキュメント生成を省略したい

**.gemrc**

```
gem: --no-rdoc --no-ri # インストール時に rdoc, ri を生成しない
:verbose: true         # 詳細メッセージを表示する
```

<small>参考
http://blog.64p.org/entry/2013/02/16/122130
</small>

---

## bundler

<small>http://bundler.io/</small>

Ruby の実行環境を "箱庭化" する gem

---

### bundler をなぜ使うのか


> アプリケーションの開発を進めていくうち「あれ、このアプリのあの機能ってあの gem 必要だけど、入ってたかな」とか「開発環境にはあるけど、実行環境ではその gem ないよ」とか嫌じゃないですか。


そんな gem の依存関係の

面倒みてくれるのが bundler です。

<small>似たような理由で rvm や rbenv なども利用しますよね :)</small>

---

### bundler の使い方

install
```
$ gem install bundler
```

bundler利用するアプリつくる

```
$ mkdir -p path/to/app
$ cd path/to/app
$ bundle init
```

ここで生成される `Gemfile` に

アプリを実行するために必要な gem を書いていく

---

### Gemfile と bundle install

Gemfile

```
# Gemfile
source "https://rubygems.org"
gem "sinatra"
```

```
$ bundle install
```

これで指定した gem （とその依存）がインストールされます

---

### bundle exec

何か sinatra アプリを動かしたい場合

```
# app.rb
require 'sinatra'
get '/' do
  'Hello world!'
end
```

```
$ bundle exec ruby app.rb
```

---

### Gemfileの補足


下記のように gem を指定することができます。

<small>http://bundler.io/v1.5/gemfile.html</small>

- version 指定
- ローカルのパスの指定
- gitリポジトリの指定
- グループの指定


---

### ここでやったこと

- gemの概要
- bundlerの概要

---

## gem / bundler

概要の説明　おわり