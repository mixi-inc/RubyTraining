## 後半(実習)

----

### 実習

- 実習の概要
- 実習の準備
  - Todoアプリの起動
  - 実習内容の共有

---

### 実習の概要

- Todo アプリを用意しました
- このアプリに対し改修を行って頂きます
- 実習の内容は後述します

---

### 実習の準備

https://github.com/mixi-inc/RubyTraining

このリポジトリを fork / clone して下さい

<small>
--

Travis CI / Code Climate / Coveralls

利用できるように作ってもあるので、

使いたい人は各サービスでリポジトリを登録しましょう

※ badgeは自分で編集してね
</small>

---

### Todoアプリの起動

```bash
$ cd RubyTraining
$ bundle install
$ rake db:migrate
$ rake db:seed
$ bundle exec rackup
```
http://localhost:9292/todos/index.html

---

### 実習の内容

http://localhost:9292/problems

--

`problems` ブランチのコードを改修していきましょう

改修後のコードも `problems` ブランチに merge/push していって下さい

---

### 提出内容

> 期限：配属前までに

> 内容：出来る所まで実施して push して下さい

<small>


--

その他

質問などありましたら、気軽に聞いて下さい

「こうするともっと良くなる」などのご意見、待ってます

是非プルリク下さい
</small>
