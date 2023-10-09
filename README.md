# [わらいず]

## サービス概要

わらいずは、予定通りの時間に起きられると報酬としてレコメンドされたお笑い動画を観ることができる、早起き促進アプリです。
タイトルは、笑いと「太陽が昇る、起床する」という意味の rise をかけています。

##　想定されるユーザー層
昼夜逆転してしまっており、早起きの習慣をつけたい人
早起きが億劫で、楽しく朝を迎えたい人

## サービスコンセプト

フルコミットでプログラミング学習をしている期間、昼夜逆転してしまうのがずっと課題でした。
昼夜逆転していると、
睡眠の質が下がり、睡眠時間が長くなる
スクールの講師の方や他の生徒の方と生活リズムが合わず、コミュニケーションが難しくなる
日中の用事ができなくなる
といったデメリットが存在し、一方メリットは特にないと感じたからです。
そして、他の生徒の方も同様の課題を感じていたので、これを解決したいと考え、本アプリを企画しました。

早起きをした方が良いのにできない大きな理由は、報酬を感じづらいからだと考えます。
例えば、目の前の美味しそうなご飯を食べたいと思うのは、美味しいという快感情の報酬を即時的に獲得できるからです。
これによりドーパミンが分泌され、該当の行動が強化されます。だから次も同じものを食べたくなるのです。
一方、早起きの報酬は即時的なものではないし、早起きによって得られる感情は、不快感情であることが多いと感じます。
結果、早起きという行動を強化できません。だから早起きを習慣化するのは難しいのです。学習の習慣化が難しいのも同様の理由だと考えます。
ならば、快感情を獲得できる即時的な報酬を別で用意すれば良いのではないかと考えました。それが youtube にアップされているお笑い動画です。
実際、予定した時間に起きられたら好きなお笑い動画を観られるというルールを自分に課した結果、昼夜逆転を改善することができました。
しかし、
お笑い動画を毎回探すのが面倒
私は元々好きなお笑い芸人がいたのでそれを見ることで快感情を容易に獲得できただけであり、他の方もそうとは限らない
という新たな課題も生まれました。
しかしこれは、ユーザーの嗜好性やニーズに合ったお笑い動画をレコメンドすることで解決できると感じました。
また、そのほかにも早起きの習慣化をサポートする機能を搭載することで、早起きという行動を強化し習慣化できる枠組みを形成したいと考えます。
競合は、現在 RUNTEQ 内でよく用いられている「おはログ！」だと考えます。
私のアプリの差別化ポイントはやはり、お笑いという要素で行動の動機付けをより強く行なっている点であると考えます。

## 実装を予定している機能

### MVP

- 会員登録
- ログイン
- お笑いの嗜好性（好みのタグ選択、自由記述、動画の長さ）設定機能
- 翌日に起床する時間を設定する機能（報酬としてレコメンドされた動画を見ることもできるし、自身でカスタムすることもできる）
- 翌朝、起床報告をし、レコメンドされた動画を視聴できる機能（設定した時間になってから 10 分は解除可能）
  ・具体的な手順
  起床 → マイページへ → 設定時間から 10 分の間、「起床」ボタンが出現するので、それを押す → 動画試聴ページにレコメンドされ、それを視聴 → 起床成功となる
- 動画が気に入らなかったら、他の動画をレコメンドしてくれる機能
  ・詳細
  もう一度同じ情報でレコメンド動画を取得します。ただし、一度レコメンドしてもらった動画を保存するテーブルを作成し、一度レコメンドされた動画は表示されないようにします。
- 起床成功後に試聴した動画と試聴成功をポスト（ツイート）できる機能
- 失敗した時にモチベを上げる動画を表示する機能
- 起床時間と起床成功 or 失敗を記録し表で振り返ることができる機能
- 起床成功回数、連続成功回数のランキング（起床時間は自分で設定したもので良い）機能(ランキング参加は任意)
- 起床時間になったことを LINE で通知する機能
- 他のユーザーの起床成功情報を一覧で見れる機能（表示は任意）

### その後の機能

- 起床成功後に、すぐ次の日の起床時間を設定することを促進する機能（これによって 1 日のタイムマネジメント意識がつく）
- 毎週末、その週の起床時間、起床成功 or 失敗を LINE でリマインドする機能
- 成功時に「なぜ成功したか」、失敗時に「なぜ失敗したか」を記録でき、振り返れる機能
- 習慣化の理論や、よくある早起き失敗例（睡眠の質が低かった等）とその解決策をまとめたコラム
- ブートキャンプ機能（1 週間の起床時間最初に全てを決めてしまい、達成率を確認できる。1 週間達成した際の報酬も最初に決める（これは大きな報酬が良いと思うので、動画じゃなくて良い））
- 称号機能（起床成功回数で称号を獲得できるもの。獲得したらポストして共有できるようにする）
- 成功 or 失敗時に睡眠時間も記録し、その時間を振り返ることができる機能
- レスポンシブデザイン対応（基本的に PC での使用を想定しているので、後からスマホにも対応させる）
- 起床成功 or 失敗時にそれを強制的にポストするように設定できる機能
- パスワードリセット機能

## Figma のリンク

https://www.figma.com/file/ZReC0nwGyNlWT20LhTTk2Q/graduation_exam-%E3%82%8F%E3%82%89%E3%81%84%E3%81%9A?type=design&node-id=0%3A1&mode=design&t=vJTmHqRe6zAULy6k-1

## ER 図

![Alt text](image.png)
