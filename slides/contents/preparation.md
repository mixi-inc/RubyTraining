## 開発環境の確認
---

### ここでやること
- ruby はいってる？
- エディタ入ってる？
- REPL使える？
 
---


## ruby はいってる？

```
$ rbenv versions
  system
* 2.1.0 (set by /Users/luckypool/.anyenv/envs/rbenv/version)

$ which gem
/Users/luckypool/.anyenv/envs/rbenv/shims/gem

$ which bundle
/Users/luckypool/.anyenv/envs/rbenv/shims/bundle
```

<small>入ってない場合は [ここ](http://qiita.com/luckypool/items/f1e756e9d3e9786ad9ea) とか [ここ](https://github.com/luckypool/Brewfile) とか参考にしてみてください</small>

---

## エディタ入ってる？

### emacs, vim, or RubyMine?

---

## REPL

対話型の実行環境使える？

irb もいいけど [pry](http://pryrepl.org/) が良いよ

```
$ gem install pry
$ pry
[1] pry(main)> puts 'hello, ruby!'
hello, ruby!
=> nil
```

---

### なくても良いけどあると便利

<img width="200" src="http://kapeli.com/dash_resources/256.png" alt="">

http://kapeli.com/dash

API Documentation Browser

---

## Are you ready? :)

