## Tesging with RSpec

---

### ここでやること

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

こんな感じ

<img src="img/tdd.png">

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

> ### StringCalculator
> 
> 文字列で入力される数字の加算結果を返す **add** というメソッドを実装しましょう
>
> 入力例 "1" or "2,4" or "3,4,6"

<small>
### spec

(1) An empty string returns zero

(2) A single number returns the value

(3) Two numbers, comma delimited, returns the sum

(4) Three numbers, comma delimited, returns the sum
</small>

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

```
$ vim spec/string_calculator_spec.rb
```

```
require "string_calculator"
describe StringCalculator do
  describe "#add" do
  	it "returns the sum"
  end
end
```

```
$ rspec spec/string_calculator_spec.rb
... cannot load such file -- string_calculator (LoadError)```
---

### pendingを確認

```
$ vim lib/string_calculator.rb
```
```
class StringCalculator
end
```

```
$ rspec spec/string_calculator_spec.rb
*
Pending:
  StringCalculator#add returns the sum
    # Not yet implemented
    # ./spec/string_calculator_spec.rb:5
```

---

### 失敗するようにspec追記

`spec/string_calculator_spec.rb`

```
require "string_calculator"
describe StringCalculator do
  let(:calc) { StringCalculator.new }
  describe "#add" do
    context "when argument is empty" do
      it "returns 0 for empty" do
        expect(calc.add("")).to eq 0
      end
    end
  end
end
```

---

### 失敗する

```
$ rspec spec/string_calculator_spec.rb
F

Failures:

  1) StringCalculator#add when argument is empty
     Failure/Error: it { expect(calc.add("")).to eq 0 }
     NameError:
       undefined local variable or method `calc' for #<RSpec::Core::ExampleGroup::Nested_1::Nested_1::Nested_1:0x007f9aac051880>
     # ./spec/string_calculator_spec.rb:6:in `block (4 levels) in <top (required)>'

Finished in 0.00035 seconds
1 example, 1 failure
```

---

### シンプルに実装しましょう


```
$ vim lib/string_calculator.rb
```

```
class StringCalculator
  def add str
    0
  end
end
```

---

### パスすることを確認

Green!

```
$ rspec spec/string_calculator_spec.rb
.

Finished in 0.00096 seconds
1 example, 0 failures
```

---

### specを更に追記

```
require 'string_calculator'
describe StringCalculator do
  let(:calc) { StringCalculator.new }
  describe "#add" do
    context "when argument is empty" do
      it "returns 0 for empty" do
        expect(calc.add("")).to eq 0
      end
    end
    context "when argument is single number" do
      it "returns 1 for 1" do
        expect(calc.add("1")).to eq 1
      end
    end
  end
end
```

---

### 失敗します

```
$ rspec spec/string_calculator_spec.rb
.F

Failures:

  1) StringCalculator#add when argument is single number returns 1 for 1
     Failure/Error: expect(calc.add("1")).to eq 1

       expected: 1
            got: 0

       (compared using ==)
     # ./spec/string_calculator_spec.rb:15:in `block (4 levels) in <top (required)>'

Finished in 0.00108 seconds
2 examples, 1 failure

Failed examples:

rspec ./spec/string_calculator_spec.rb:14 # StringCalculator#add when argument is single number returns 1 for 1```

---

### `lib/string_calculator.rb` の修正

```
class StringCalculator
  def add str
    return 0 if str.empty?
    1
  end
end
```

そしてGreen

```
$ rspec ./spec/string_calculator_spec.rb
..

Finished in 0.00099 seconds
2 examples, 0 failures
```

---

### また spec の追記

```
+    context "when argument is two numbers (comma delimited)" do
+      it "returns 2 for 1,1" do
+        expect(calc.add("1,1")).to eq 2
+      end
+    end
```

実行結果は省略

もちろん **失敗** するはずですね

---

### パスするように実装

```
class StringCalculator
  def add str
    return 0 if str.empty?
    return 1 unless str.include?(",")
    2
  end
end
```

実行結果は省略

---

### また同様に

spec追加
```
+    context "when argument is three numbers (comma delimited)" do
+      it "returns 3 for 1,1,1" do
+        expect(calc.add("1,1,1")).to eq 3
+      end
+    end
```

失敗する
```
$ rspec spec/string_calculator_spec.rb
```

実装追加でGreen!

```
class StringCalculator
  def add str
    return 0 if str.empty?
    numbers = str.split(",")
    return 1 if numbers.size == 1
    return 2 if numbers.size == 2
    3
  end
end
```


---

### 閑話休題

Formatter 変えて実行してみよう

```
$ rspec spec/calculator_spec.rb --format doc
StringCalculator
  #add
    when argument is empty
      returns 0 for empty
    when argument is single number
      returns 1 for 1
    when argument is two numbers (comma delimited)
      returns 2 for 1,1
    when argument is three numbers (comma delimited)
      returns 3 for 1,1,1

Finished in 0.00181 seconds
4 examples, 0 failures
```

<small>
[progress(defoult)](http://kerryb.github.io/iprug-rspec-presentation/#10) /
[documentation](http://kerryb.github.io/iprug-rspec-presentation/#12) /
[html](http://kerryb.github.io/iprug-rspec-presentation/#13) /
[fuubar](http://kerryb.github.io/iprug-rspec-presentation/#14)

オプションは `.rspec` にまとめて書いておいてもOK
</small>

---

### spec追加

```
+      it "returns 2 for 2" do
+        expect(calc.add("2")).to eq 2
+      end
```

```
+      it "returns 2 for 1,2" do
+        expect(calc.add("1,2")).to eq 3
+      end
```

```
+      it "returns 3 for 1,2,3" do
+        expect(calc.add("1,2,3")).to eq 6
+      end
```

これで失敗を確認

---

### 実装追加

```
class StringCalculator
  def add str
    return 0 if str.empty?
    numbers = str.split(",")
    return numbers[0].to_i if numbers.size == 1
    return numbers[0].to_i + numbers[1].to_i if numbers.size == 2
    numbers[0].to_i + numbers[1].to_i + numbers[2].to_i
  end
end
```

specがパスすることを確認する

---

### リファクタリングする

```
class StringCalculator
  def add str
    return 0 if str.empty?
    numbers = str.split(",").map {|x| x.to_i }
    return numbers[0] if numbers.size == 1
    return numbers[0] + numbers[1] if numbers.size == 2
    numbers[0] + numbers[1] + numbers[2]
  end
end
```

もちろん Green を確認する

---

### もうちょいシンプルにできそう

```
class StringCalculator
  def add str
    return 0 if str.empty?
    str.split(",").map(&:to_i).inject(:+)
  end
end
```

もちろん Green

---

### 続きはこの辺を参考に :)

<small>

http://www.peterprovost.org/blog/2012/05/02/kata-the-only-way-to-learn-tdd

http://osherove.com/tdd-kata-1/

http://vimeo.com/7961506
</small>

---

## RSpec補足

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
it { should be_empty } # still keep one-liner syntax
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

### Types/classes

```
expect(actual).to be_an_instance_of(expected) 
expect(actual).to be_a(expected)
expect(actual).to be_an(expected)
expect(actual).to be_a_kind_of(expected)
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

### Truthiness and existentialism

```
expect(actual).to be_truthy
expect(actual).to be true
expect(actual).to be_falsy
expect(actual).to be false
expect(actual).to be_nil
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


## let / let!

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

`let` は 遅延評価なのに対し

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

example / esample group 毎の前後に

実行したい場合はこの hook を使う

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
