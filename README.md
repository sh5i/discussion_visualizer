# Discussion Visualizer

## 1. 導入方法

- 必要ライブラリをインストールする(Macならbrewで入れられるはず)
    - Rails 5.0.0
    - ruby 2.3.1
    - graphviz
- bitbucket から clone する
- terminal で、プロジェクトディレクトリに移動する
- gem を導入する(必要に応じて`bundle update` してください)
```
bundle install
```
- DB を作成する
```
bundle exec rake db:create
```
- テーブルを作成する
```
bundle exec rake db:migrate
```
- 初期データを入稿する
```
bundle exec rake db:seed
```