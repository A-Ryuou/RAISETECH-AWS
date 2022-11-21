# 第10回課題報告

* CloudFormation を利用して、現在までに作った環境をコード化する

<br>
<br>

## 作成するAWSリソースの整理

<br>

* VPC
* サブネット(RDS用のサブネットグループも)
* ルートテーブル
* インターネットゲートウェイ
* セキュリティグループ
* EC2インスタンス
* RDSインスタンス
* S3バケット
* ELB(ALB)
* ALB用のターゲットグループ
* Elastic IP
* CloudWatchアラーム
* SNS
* VPC フローログ

<br>
<br>

VPCとネットワーク関係のテンプレート設定が煩雑そうだったので書き出してみる。()内はリソースタイプ。

<br>

1. VPC作成（AWS::EC2::VPC)
2. IGW作成（AWS::EC2::InternetGateway)
3. IGWをVPCにアタッチ(AWS::EC2::VPCGatewayAttachment)
4. ルートテーブル作成(AWS::EC2::RouteTable)
5. 作成したルートテーブルにルーティングを設定(AWS::EC2::Route)
6. サブネット作成(AWS::EC2::Subnet)
7. ルートテーブルをサブネットに関連付け(AWS::EC2::SubnetRouteTableAssociation)

<br>
<br>

作成したテンプレートは、このファイルと同じディレクトリ内(CFnTemplates)に保存した。（動作確認済み）  
テンプレートで作成されるリソースだけで完結するように設定したつもりである。  

依存関係があるため下記の順にスタックを作成する。

<br>

1. NetWork.yaml
2. SecurityGroup.yaml
3. EC2.yaml
4. RDS.yaml
5. S3Bucket.yaml
6. ALB-Alarm.yaml

<br>
<br>

また、今回はnginx+unicornでサンプルアプリの起動まで確認できているAMIイメージをもとにEC2インスタンスを作成したが、動作確認の際に設定変更が必要だったので備忘録のため下記に記しておく。

<br>

* ```config/database.yml```を編集し、CloudFormationで作成したRDSのマスターユーザー、マスターパスワード、ホストに変更する。
* ```bundle exec rails db:create```および```bundle exec rails db:migrate```の実行
* nginxの.confファイルのserver_nameを新規作成EC2のパブリックIPに変更

<br>

※ALBを噛ませる前に接続確認したい場合は、EC2用のセキュリティグループのインバウンドルールに一旦手動でHTTP（ポート80）のプロトコルに対しすべてのIPv4アドレスからの接続を許可する。（確認できたら削除）

<br>
<br>
<br>

## 感想

<br>

* もともとVBAなどで業務を自動化するのが好きだったため、積極的に課題に取り組むことができた。

* VSCodeでコードを書いたが、CloudFormation用の拡張機能により構文のエラーはスタック作成までに潰すことができたので第5回課題などと比べるとスムーズに課題を進められたのでよかった。スタック作成時のエラーも、Cloudtrailを参照すればエラー原因がわかりやすく記載されてあったので助かった。

* !Ref と!GetAttは、どの値を参照したいかに応じて使い分けしなければならないので注意しないといけないと思った。

* 今回の課題では数種類の組み込み関数しか利用せず、また、MetaDataセクションやMappingsセクションなどは使用しなかったが実際の現場では必須の知識だと思うので公式ドキュメントなどを参考にして身につけたい。



