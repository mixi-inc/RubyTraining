## ActiveRecord

---

### ここでやること

- ActiveRecordの概要
  - ActiveRecordとは？
  - 「設定より規約」
- コードで紹介
  - Modelの作り方
  - CRUC操作
  - Validations
  - Migrations
  
---

### ActiveRecordとは？

[Martin Fowler氏](http://martinfowler.com/) が定義した

[Active Record Pattern](http://www.martinfowler.com/eaaCatalog/activeRecord.html) に由来します

<small>

MVCパターンの Model を担当するもので

Rails にて O/Rマッパー として利用されてるのは有名ですね
</small>

---

### Active Record Pattern:

> <small> An object that wraps a row in a database table or view,
> 
> capsulates the database access, and adds domain logic on that data.


--


データベースのテーブルあるいはビューの row が

1つのクラスにラップされ

オブジェクトのインスタンスがデータベースの1行に結合される

DBアクセスをカプセル化し、

ドメインロジックも追加できる
</small>

---

### ActiveRecord でできること


<small>
--

Modelやその**データ**を表すこと

Model間の**リレーション**を表すこと

関係するモデルの**継承関係**を表すこと

DBに永続化する前にModelを**バリデーション**すること

**オブジェクト指向**っぽくDB操作すること
</small>

---

### 設定より規約

<small>[Convention over Configuration](http://ja.wikipedia.org/wiki/%E8%A8%AD%E5%AE%9A%E3%82%88%E3%82%8A%E8%A6%8F%E7%B4%84)</small>

![](http://guides.rubyonrails.org/images/belongs_to.png)

<small>
<small>
画像の参考：[Active Record Associations — Ruby on Rails Guides](http://guides.rubyonrails.org/association_basics.html)
</small>

**名前の規約**

Orderクラスは `orders` テーブル


**スキーマの規約**

外部キーは　`table_name_id`

主キーはデフォルトで `id`　等
</small>

---

コードで理解していきましょう！ :)

---

サンプルコード用意しました

```bash
$ ce /path/to/workspace
$ git clone https://github.com/luckypool/activerecord-example.git
$ cd activerecord-example
$ bundle install
```

---

### やってみよう

```
$ rake db:migrate
```

```
$ bundle exec ruby crud.rb
```
<small>
pryが起動しますので `step` や `next` で進めていきましょう
</small>
<small>
`tail -f db/database.log` したり `sqlite3 db/sample.sqlite3` でデータ覗いてみましょう
</small>

---

### 補足

---

### Modelの作り方

`users` テーブルがあったとして、

```
CREATE TABLE users (
   id int(11) NOT NULL auto_increment,
   name varchar(255),
   PRIMARY KEY  (id)
);
```

これに対応する Model の作り方はとても簡単

```ruby
# models/user.rb
class User < ActiveRecord::Base
end
```

---

### CRUD 操作 (create)

```ruby
user = User.create(name: "David")
```

or

```ruby
user = User.new
user.name = "David"
user.save
```

or

```ruby
user = User.new do |u|
  u.name = "David"
end
user.save
```

means 

```
INSERT INTO users (name) VALUES ("David");
```

---

### CRUD 操作 (read)

全件取得

```ruby
users = User.all
```
means
```
SELECT * FROM users
```

１件取得

```ruby
users = User.find_by(id: 1)
```
means
```
SELECT * FROM users WHERE id = 1 LIMIT 1
```

---

### CRUD 操作 (update)

```ruby
user = User.find_by(id: 1)
user.name = 'Dave'
user.save
```
or
```
user = User.find_by(id: 1)
user.update(name: 'Dave')
```

means

```
UPDATE users SET name = 'Dave' WHERE id = 1
```

---

### CRUD 操作 (delete)

```ruby
user = User.find_by(id: 1)
user.destroy
```
means

```
DELETE FROM users WHERE id = 1
```

---

### Validations

```ruby
# models/user.rb
class User < ActiveRecord::Base
  validates :name, presence: true
end
```

```ruby 
User.create  # => false
User.create! # => ActiveRecord::RecordInvalid: Validation failed: Name can't be blank
```

<small>
詳しくは

[Active Record Validations — Ruby on Rails Guides](http://guides.rubyonrails.org/active_record_validations.html)

[Active Record Callbacks — Ruby on Rails Guides](http://guides.rubyonrails.org/active_record_callbacks.html)
</small>

---

### Migrations

```ruby
# db/migrate/20140411074321_create_users.rb
class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.timestamps
    end
  end
end
```

```
CREATE TABLE "users" (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  "name" varchar(255),
  "created_at" datetime,
  "updated_at" datetime
);
```
<small>
詳しくは
[Active Record Migrations — Ruby on Rails Guides](http://guides.rubyonrails.org/migrations.html)
</small>

---

### ここでやったこと
- ActiveRecordの概要
  - ActiveRecordとは？
  - 「設定より規約」
- 簡単チュートリアル
  - Modelの作り方
  - CRUC操作
  - Validations
  - Migrations

---

### ActiveRecord

おわり

<small>
--

[Rails Guides](http://guides.rubyonrails.org/)

[Ruby on Rails3で学ぶWeb開発のキホン（3）](http://www.atmarkit.co.jp/ait/articles/1104/12/news135.html)
</small>
