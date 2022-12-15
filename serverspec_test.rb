
require 'spec_helper'

listen_port = 80

# 22年11月のサンプルアプリアップデート前の環境に限る

#nodeとyarnについては、テスト前に「source ~/.nvm/nvm.sh」を実行してnvmのパスを通すか、/home/ec2-user/.bash_profileを編集する。

# nginxのインストール確認
describe package('nginx') do
  it { should be_installed }
end

# mysqlのインストール確認
describe package('mysql-community-server') do
  it { should be_installed }
end

# rubyのバージョンが2.6.3か確認
describe command('ruby -v') do
  its(:stdout) { should match /ruby 2.6.3p62*/ }
end

# railsのバージョンが6.1.3.1か確認
describe command('rails -v') do
  its(:stdout) { should match /Rails 6.1.3.1/ }
end

# nodeのバージョンが14.20.1か確認
describe command('node -v') do
  its(:stdout) { should match /v14.20.1/ }
end

# yarnのバージョンが1.22.19か確認
describe command('yarn -v') do
  its(:stdout) { should match /1.22.19/ }
end

# webpackerのインストール確認
describe command('cat ../raisetech-live8-sample-app/package.json') do
  its(:stdout) { should contain('@rails/webpacker') }
end

# 80番ポートが空いているか確認
describe port(listen_port) do
  it { should be_listening }
end

# テスト接続が成功するかどうか
describe command('curl http://127.0.0.1:#{listen_port}/_plugin/head/ -o /dev/null -w "%{http_code}\n" -s') do
  its(:stdout) { should match /^200$/ }
end

























