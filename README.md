FBC の Sinatra の課題で作成したメモアプリです。
## 立ち上げの準備
1. `git clone https://github.com/SuzukaHori/sinatra_practice.git`で、ローカルにクローンしてください。
1. `cd sinatra_practice`でsinatra_practiceディレクトリに移動してください。
1. `bundle install`を実行し、Gem をインストールしてください。
1. PostgreSQLを起動してください。<br>
  macの場合：`brew services start postgresql`<br>
  windowsの場合：`net start postgresql-x64-[PostgreSQLのバージョン]`<br>
  Linuxの場合：`service postgresql start`
1. `psql -U [ユーザ名もしくはpostgres]`で、任意のデータベースに接続してください。
1. `CREATE DATABASE memosdata;`を実行し、データベースを作成してください。
1. `\q`でデータベースからターミナルに戻ってください。
1. `psql memosdata < dbinit.sql`でSQL文を実行し、テーブル・カラムを作成します。

## 起動方法
1. `bundle exec ruby app.rb`で、アプリケーションを起動してください。
1. http://localhost:4567/ にアクセスすると、メモアプリが表示されます。
