## Tesging with RSpec

---

## これからやること

- RSpecの概要
  - TDD / BDD
- 簡単チュートリアル
  - describe / context / it
  - built-in matchers
  - let

---

## RSpec

> RSpec is testing tool for the Ruby programming language.
Born under the banner of Behaviour-Driven Development,
it is designed to make Test-Driven Development a productive and enjoyable experience with features like:
<small><ul>
<li>a rich command line program (the rspec command)</li>
<li>textual descriptions of examples and groups (rspec-core)</li>
<li>flexible and customizable reporting</li>
<li>extensible expectation language (rspec-expectations)</li>
<li>built-in mocking/stubbing framework (rspec-mocks)</li>
</ul></small>

<small>http://rspec.info/</small>


---

## RSpecとは (ざっくり)


**TDD (Test-Driven Development)**

をより良く楽しく

**BDD (Behaviour-Driven Development)**

出来るようにする

テストフレームワーク

---

### TDD (Test-Driven Development)

大まかな開発プロセス

> - プロダクトコードの前に**先ずテストコード**を書き、失敗することを確認する
> - テストに成功するよう**プロダクトコードを書く**
> - テストに失敗しないよう**リファクタリング**
> - (最初に戻る)

<small>参考: [テスト駆動開発](http://ja.wikipedia.org/wiki/%E3%83%86%E3%82%B9%E3%83%88%E9%A7%86%E5%8B%95%E9%96%8B%E7%99%BA)</small>

---

### BDD (Behaviour-Driven Development)

基本的にはTDD

> プログラムの期待する **振る舞い(仕様)** を
> 
> 自然言語に近い形として記述していく
>
> テスト　→　**スペック**

<small>詳しくはコードを見てみよう :)</small>

<!--
Behaviourがイギリス英語なのは、BDDの提唱者 Dan North がイギリス人だから？ http://dannorth.net/about/
-->
---

## Test::Unit の場合

<small>
https://gist.github.com/luckypool/dcf54fc81934ff9fb962
</small>

```
require 'test/unit'
require './bowling'
class TC_Bowling < Test::Unit::TestCase
  def setup
    @obj = Bowling.new
  end
  def test_score
    assert_equal(0, @obj.score)
  end
  def teardown
    @obj = nil
  end
end
```

---

## RSpec の場合

<small>
https://gist.github.com/luckypool/dcf54fc81934ff9fb962
</small>

```
require './bowling'
describe Bowling do
  context 'when no hit' do
    its(:score) { should eq 0 }
  end
end
```

---

### RSpec の DSL

> "**Describe** an account when it is first opened."
> 
> "**It** has a balance of zero."

RSpecはDSLによって、自然言語のように、

コードに期待する振る舞いを記述できるようにしている

<small>
[basic structure (describe/it) - Example groups - RSpec Core - RSpec - Relish](https://www.relishapp.com/rspec/rspec-core/v/2-14/docs/example-groups/basic-structure-describe-it)
</small>
---

## 実行結果の違い

Test::Unit

<img src="img/result_test_unit.png" width=80%>

RSpec

<img src="img/result_rspec.png" width=80%>

---

## 違いがありますね :)

これから、実際に手を動かしながら

RSpec の基礎的なところを

実践していきましょう

---

### 簡単TDDチュートリアル

- describe / context / it
- built-in matcher
- implicit subject
- let

---

> ### Calculator
> 
> 2つの数を加算して返す **add** というメソッドを
> 
> 実装したいということにしましょう
> 
> まず spec を書いてみましょう

---

### 準備

```
$ cd path/to/your/workspace
　
$ gem install rspec
　
$ mkdir rspec-tutorial
$ cd rspec-tutorial
```

---

### spec 書いて失敗してみる

<small>コピペでOKです</small>

```
$ vim spec/calculator_spec.rb
```

```
describe Calculator do
  let(:calc) { Calculator.new }
  describe "#add" do
    context "when arguments 2 and 3" do
      it { expect(calc.add(2,3)).to eq 5 }
    end
  end
end
```

```
$ rspec spec/calculator_spec.rb
./spec/calculator_spec.rb:1: uninitialized constant Calculator
```

---

### シンプルに実装しましょう

<small>コピペでOKです</small>

```
$ vim lib/calculator.rb
```

```
class Calculator
  def add(a,b)
    a + b
  end
end
```

---

### `spec/calculator_spec.rb` で下記を追記

<small>コピペでOKです</small>

```
require "calculator"
```

これで rspec 実行

```
$ rspec spec/calculator_spec.rb
.
　
Finished in 0.000315 seconds
1 example, 0 failures
```

---

### Formatter

```
$ rspec spec/calculator_spec.rb --format doc
Calculator
  #add
    when arguments 2 and 3
      should eq 5
　　　
Finished in 0.000379 seconds
1 example, 0 failures
```

<small>
[progress(defoult)](http://kerryb.github.io/iprug-rspec-presentation/#10) /
[documentation](http://kerryb.github.io/iprug-rspec-presentation/#12) /
[html](http://kerryb.github.io/iprug-rspec-presentation/#13) /
[fuubar](http://kerryb.github.io/iprug-rspec-presentation/#14)

オプションは `.rspec` にまとめて書いておいてもOK
</small>

---

## 補足

<small>
http://betterspecs.org/jp/

https://www.relishapp.com/rspec/rspec-core/v/2-14/docs

https://www.relishapp.com/rspec/rspec-core/v/3-0/docs
</small>

下記のスライドは流す程度で紹介します

---

### Basic Structure

describe / context / it

```
describe "something" do
  context "in one context" do
    it "does one thing" do
    end
  end
  context "in another context" do
    it "does another thing" do
    end
  end
end
```

<small>
解説

**describe** : 対象の説明 / クラス・モジュール・メソッド等 / [RSpec::Core::ExampleGroup](https://github.com/rspec/rspec-core/blob/master/lib/rspec/core/example_group.rb)

**context** : 状況の説明 / "when" や "with" で説明 / describeと同じExampleGroup

**it** : Spec の説明 / 40文字以内で記述 / 省略OK / [RSpec::Core::Example](https://github.com/rspec/rspec-core/blob/master/lib/rspec/core/example.rb) 
</small>

---

## expectation

---

### should v.s. expect

http://myronmars.to/n/dev-blog/2012/06/rspecs-new-expectation-syntax

- `should` を使わないようにしていく
- けど the one-liner `should` はまだ使う
- 詳しくはリンク先のコメント

```
it { should be_empty } # still keep
it "returns empty" do
  [].should be_emplty # not recommended
end
```

---

## built-in matchers

[rspec-expectation](https://github.com/rspec/rspec-expectations)

[built-in-matchers 3.0](https://www.relishapp.com/rspec/rspec-expectations/v/3-0/docs/built-in-matchers) / 
[built-in-matchers 2.14](https://www.relishapp.com/rspec/rspec-expectations/v/2-14/docs/built-in-matchers)

---

### Equivalence

```
expect(actual).to eq(expected)
expect(actual).to eql(expected)
```

<small>
Note : The new expect syntax no longer supports the == matcher.
</small>

---

### Identity

```
expect(actual).to be(expected)
expect(actual).to equal(expected)
```

---

### Comparisons

```
expect(actual).to be >  expected
expect(actual).to be >= expected
expect(actual).to be <= expected
expect(actual).to be <  expected
expect(actual).to be_within(delta).of(expected)
```

---

### Regular expressions

```
expect(actual).to match(/expression/)
```

<small>
Note : The new expect syntax no longer supports the =~ matcher.
</small>

---

### Types/classes

```
expect(actual).to be_an_instance_of(expected) 
expect(actual).to be_a(expected)
expect(actual).to be_an(expected)
expect(actual).to be_a_kind_of(expected)
```

---

### Truthiness and existentialism

```
expect(actual).to be_truthy
expect(actual).to be true
expect(actual).to be_falsy
expect(actual).to be false
expect(actual).to be_nil
```

---

### Expecting errors

```
expect { ... }.to raise_error
expect { ... }.to raise_error(ErrorClass)
expect { ... }.to raise_error("message")
expect { ... }.to raise_error(ErrorClass, "message")
```

---

### Predicate matchers

```
expect(actual).to be_xxx # passes if actual.xxx?
expect(actual).to have_xxx(:arg) # passes if actual.has_xxx?(:arg)
```
例
```
expect([]).to be_empty
expect(:a => 1).to have_key(:a)
```

---


### let / let!

[RSpec::Core::MemoizedHelpers](https://github.com/rspec/rspec-core/blob/master/lib/rspec/core/memoized_helpers.rb)

同一の Example 内でオブジェクトを使いまわせる。

---

重複があってかっこわるい

```
describe BowlingGame do
  it "scores all gutters with 0" do
    game = BowlingGame.new
    20.times { game.roll(0) }
    it { expect(game.score) eq 0 }
  end

  it "scores all 1s with 20" do
    game = BowlingGame.new
    20.times { game.roll(1) }
    it { expect(game.score) eq 20 }
  end
end
```

---

`before` ブロックで example 毎に new する

でも `let` の方が better

```
describe BowlingGame do
  before do
    @game = BowlingGame.new
  end
 
  it "scores all gutters with 0" do
    20.times { @game.roll(0) }
    it { expect(@game.score) eq 0 }
  end

  it "scores all 1s with 20" do
    20.times { @game.roll(1) }
    it { expect(@game.score) eq 20 }
  end
end
```

---

`let` は遅延評価でメモ化（spec終わるまでキャッシュ）してくれる

```
describe BowlingGame do
  let(:game) { BowlingGame.new }
 
  it "scores all gutters with 0" do
    20.times { game.roll(0) }
    it { expect(game.score) eq 0 }
  end
 
  it "scores all 1s with 20" do
    20.times { game.roll(1) }
    it { expect(game.score) eq 20 }
  end
end
```

---

注意

`let!` は before hook で評価される

[lib/rspec/core/memoized_helpers.rb#L299](https://github.com/rspec/rspec-core/blob/master/lib/rspec/core/memoized_helpers.rb#L299)

---

## Implicit / Explicit subject

```
describe Array do
  # subject { Array.new } なくてok
  it { should be_empty }
  its(:size) { should == 0 }
end
```

`describe` の引数は `subject` になる

クラスを指定した場合は subject は instance になる

---

## Before and after hooks

https://www.relishapp.com/rspec/rspec-core/v/2-14/docs/hooks/before-and-after-hooks

example 毎に実行したい場合はこの hook を使う

---

## Shared examples

```
shared_examples_for "a single-element array" do
  it { should_not be_empty }
  it { should have(1).element }
end
 
describe ["foo"] do
  it_behaves_like "a single-element array"
end
 
describe [42] do
  it_behaves_like "a single-element array"
end
```

共通の example をまとめることが出来る

---

### ここまでやったこと

- RSpecの概要
  - TDD / BDD
- 簡単チュートリアル
  - describe / context / it
  - built-in matchers
  - let
  
　

<small>
色々紹介しすぎた感もあるので、

詳細はドキュメントで

http://betterspecs.org/jp/

https://www.relishapp.com/rspec/rspec-core/v/2-14/docs

https://www.relishapp.com/rspec/rspec-core/v/3-0/docs
</small>

---

## Tesging with RSpec

おわり
