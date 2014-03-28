# 2014 Ruby 研修問題

## 便利なリファレンス

- [Sinatra Documentation](http://www.sinatrarb.com/intro-jp.html)
- [RSpec 2.14 Built-in Matchers](https://www.relishapp.com/rspec/rspec-expectations/v/2-14/docs/built-in-matchers)
- [Better Specs](http://betterspecs.org/jp/)
</section>

## 問題

### 問題.1

`/404`にアクセスすると、Not Foundと表示されますが、実際には静的なhtmlへredirectしているだけです。<br>
これをHTTPステータスコード 404を返すよう修正してください。

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

### 問題.2

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
