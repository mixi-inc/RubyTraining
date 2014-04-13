## **Ruby**

---

### ここでやること
- Ruby の概要
- 記法等
  - 基礎 / リテラル / 変数と定数
  - 演算子式 / 制御構造
  - クラスとメソッド定義

---

## Ruby

#### [Matz氏](https://twitter.com/yukihiro_matz)により1993年に公開
#### 国産のオブジェクト指向言語
#### OSSコミュニティにより開発が今なお継続

---

## 特徴

#### 動的型付け言語
#### プリミティブ型のようなものはない
#### ガベージコレクション

<small>
 

Ruby 2.1.0 リファレンスマニュアル > ライブラリ一覧 > [組み込みライブラリ](http://docs.ruby-lang.org/ja/2.1.0/library/_builtin.html)
</small>

---

## ビジネス用途でもよく使われてる

<small>
参考：[国内注目のWebサービスを支える言語・フレームワーク・アーキテクチャ一覧【2013年版】 | Find Job ! Startup](http://www.find-job.net/startup/architecture-2013)
</small>

---

## 処理系

### [MRI](http://www.ruby-lang.org/)(Matz' Ruby Implementation)

Matz氏によって開発されてる、C言語で実装されたRubyの公式処理系。

CRubyとも呼ばれる。

---

## 他の処理系

[JRuby](http://www.jruby.org/) /
[IronRuby](http://ironruby.net/) /
[MacRuby](http://www.macruby.org/) /
[Rubinius](http://rubini.us/) /
[MagLev](http://maglev.github.com/) /
[Cardinal](https://github.com/parrot/cardinal) /
[Ruby.NET](http://rubydotnet.googlegroups.com/web/Home.htm) /
[XRuby](http://code.google.com/p/xruby/) /
[HotRuby](http://hotruby.yukoba.jp/)


関連: [mruby](https://github.com/mruby/mruby) / [RubyMotion](http://www.rubymotion.com/)

<small>
参考: [Ruby処理系の概要](http://www.ruby.or.jp/ja/tech/install/ruby/implementations.html)
</small>

---

## オフィシャルサイト等

公式 https://www.ruby-lang.org/ja/

日本Rubyの会（Rubyist Magazine） http://magazine.rubyist.net/

リファレンス・マニュアル http://docs.ruby-lang.org/ja/

---

## 知っておくと良いもの

### Ruby Toolbox

<small>https://www.ruby-toolbox.com/</small>

<small>人気のgemがジャンルごとに一覧できる</small>

### Ruby Style Guide

<small>https://github.com/bbatsov/ruby-style-guide</small>

<small>http://www.ruby.or.jp/ja/tech/development/ruby/050_coding_rule.html</small>

<small>rubyらしいコードを書くために :)</small>

---

## Rubyのプログラム（基礎）

### hello.rb

```
# hello.rb
puts "hello, ruby!"
```

- プログラムの拡張子は .rb
- 行末には ; いらない。改行が文末を表す

```bash
$ ruby hello.rb
hello, ruby!
```

---

## 変数と定数

ローカル変数    : 小文字または _ ではじまる

インスタンス変数: @ ではじまる

クラス変数      : @@ ではじまる

グローバル変数  : $ ではじまる

定数            : 英大文字



<small>
参考: Ruby 2.1.0 リファレンスマニュアル > [変数と定数](http://docs.ruby-lang.org/ja/2.1.0/doc/spec=2fvariables.html)
</small>

---

## リテラル

[Array](http://docs.ruby-lang.org/ja/2.1.0/class/Array.html)
```
[1, 2, 3]
%w(a b c)
```


[Hash](http://docs.ruby-lang.org/ja/2.1.0/class/Hash.html)
```
{ 1 => 2, 2 => 4, 3 => 6}
{ a:"A", b:"B", c:"C" }
```


[Symbol](http://docs.ruby-lang.org/ja/2.1.0/class/Symbol.html)
```
:lvar
:+
```


<small>
参考: Ruby 2.1.0 リファレンスマニュアル > [リテラル](http://docs.ruby-lang.org/ja/2.1.0/doc/spec=2fliteral.html)
</small>

---

## 演算子式

```
1+2*3/4　　　# * / % が + 0 よりも優先度高い
```


代入
```
foo = bar　　　# 代入
foo, bar, baz = 1, 2, 3　　　# 多重代入
```


[Range](http://docs.ruby-lang.org/ja/2.1.0/class/Range.html)
```
1..20
```



条件演算子
```
obj == 1 ? foo : bar
```



<small>
参考: Ruby 2.1.0 リファレンスマニュアル > [演算子式](http://docs.ruby-lang.org/ja/2.1.0/doc/spec=2foperator.html)
</small>

---

## 制御構造

```
if age >= 12 then
  print "adult fee\n"
else
  print "child fee\n"
end
```

```
for i in [1, 2, 3]
  print i*2, "\n"
end
```

```
begin
  raise "error message"
rescue => e
  p $!
  p e
end
# => #<RuntimeError: error message>
     #<RuntimeError: error message>
```

<small>
[Kernal.#fail](http://docs.ruby-lang.org/ja/2.1.0/method/Kernel/m/raise.html)
</small>

<small>
参考: Ruby 2.1.0 リファレンスマニュアル > [演算子式](http://docs.ruby-lang.org/ja/2.1.0/doc/spec=2foperator.html)
</small>

---

## メソッド呼び出し

```
foo.bar()
foo.bar
bar()
print "hello world\n"
Class.new
Class::new
```

<small>
参考: Ruby 2.1.0 リファレンスマニュアル > [メソッド呼び出し(super・ブロック付き・yield)](http://docs.ruby-lang.org/ja/2.1.0/doc/spec=2fcall.html)
</small>

---

## クラス/メソッドの定義

```
class Foo < Super
  def foo(a, b)  # 引数は括弧を省いてdef foo a, bとも
    a + 3 * b
  end
end

module Foo
  def hello    # 引数のないメソッド。
    puts "Hello, world!"
  end
end
```
<small>
[Class](http://docs.ruby-lang.org/ja/2.1.0/class/Class.html)クラスは[Module](http://docs.ruby-lang.org/ja/2.1.0/class/Module.html)クラスから継承されている
</small>


<small>
参考: Ruby 2.1.0 リファレンスマニュアル > [クラス／メソッドの定義](http://docs.ruby-lang.org/ja/2.1.0/doc/spec=2fdef.html)
</small>

---

## 確認

https://gist.github.com/luckypool/95286c58d53d4c60a985

```
$ git clone https://gist.github.com/95286c58d53d4c60a985.git hoge
$ cd hoge
$ pry
[1] pry(main)> require './hoge.rb'
=> true
```

---

### それぞれ何が表示されるでしょう？(1/2)

https://gist.github.com/luckypool/95286c58d53d4c60a985

```
# (1)
CONST_VAR
# => ?

# (2)
instance = Hoge.new 'hoge'
instance.foo
# => ?

# (3)
Hoge.foo
# => ?
```

---

### それぞれ何が表示されるでしょう？(2/2)

https://gist.github.com/luckypool/95286c58d53d4c60a985

```
# (4)
instance.bar do |a,b,c,d|
  [a,b,c,d]
end
# => ?

# (5)
sub = Fuga.new 'fuga'
sub.foo
# => ?

# (6)
Hoge.bar do |a,b,c,d|
  [a,b,c,d]
end
# => ?


```

---

### ここでやったこと
- Ruby の概要
- 記法等
  - 基礎 / リテラル / 変数と定数
  - 演算子式 / 制御構造
  - クラスとメソッド定義

---

## Rubyの復習おわり :)


