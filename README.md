# ローカルでのアプリケーション立ち上げ方法

1. 本リポジトリをローカルにcloneして、リポジトリに移動する

```
git clone https://github.com/Utsubo256/sinatra-app.git
cd sinatra-app
```

2. Bundlerを使ってgemをインストールする

```
bundle install
```

3. 用意されている.env.sampleファイルをコピして.envファイルを作成する

```
cp .env.sample .env
```

4. envファイルの環境変数に使用しているPostgreSQLのデーターベース名、ユーザー名を書き込む

```ruby
DB_NAME=db_name
USER_NAME=user_name
```

5. アプリケーションを立ち上げる

```
bundle exec rerun app.rb
```
