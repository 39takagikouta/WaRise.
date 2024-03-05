# WaRise. / 「お笑い」と「アラーム」を合わせた、早起き促進サービス

![Alt text](image-3.png)

## サービス概要

WaRise（わらいず）は、設定時間に起床すると、ご褒美としてお笑い動画をレコメンドしてくれる、早起き促進アラームアプリです。

プログラミング学習中、昼夜逆転の生活になってしまうことが課題で、スクール内の多くの受講生も同様の問題を抱えていました。
早起きの習慣化が難しい原因は、早起きはやった方が良いが辛いものである点だと考えたため、報酬によってそれを楽しいものにできるように本アプリを作成しました。

### ▼ サービス URL

https://www.wa-rise.com

レスポンシブ対応済のため、PC でもスマートフォンでも快適にご利用いただけます。

### ▼ 開発者 Twitter

https://twitter.com/YA3lrpq2PnRc3ge

何かございましたら、こちらまでお気軽にご連絡ください。

## メイン機能

<table>
  <tr>
    <th style="text-align: center">アラーム機能</th>
    <th style="text-align: center">LINEのトーク上でアラームを設定、動画を視聴</th>
  </tr>
  <tr>
    <td>
      <a href="https://gyazo.com/1d06c8cc2cc654fbf39ff28cc57db733"><img src="https://i.gyazo.com/1d06c8cc2cc654fbf39ff28cc57db733.gif" alt="Image from Gyazo" width="372"/></a>
      アラームの時刻になったらLINEで通知をします。<br/>
      10分以内に、あなたの嗜好に合わせてレコメンドされたお笑い動画を視聴しましょう（表示される動画を選ぶこともできます）。<br/>
      以前のアラーム情報は記録され、カレンダーでいつでも振り返ることができます。
    </td>
    <td>
      <a href="https://gyazo.com/db51d65e1b1607b10446c41d024c9ddc"><img src="https://i.gyazo.com/db51d65e1b1607b10446c41d024c9ddc.jpg" alt="Image from Gyazo" width="506"/></a>
      アラーム機能は公式LINEとのトーク画面でも使用できます！<br/>
      使い方はトーク画面にあるメニューからご確認ください。
    </td>
  </tr>
  <tr>
    <th style="text-align: center">カレンダー機能</th>
    <th style="text-align: center">みんなの起床情報</th>
  </tr>
  <tr>
    <td>
      <a href="https://gyazo.com/2abf76dd86369ffcb6062a8eacc29026"><img src="https://i.gyazo.com/2abf76dd86369ffcb6062a8eacc29026.png" alt="Image from Gyazo" width="317"/></a>
      以前のアラーム情報は記録され、カレンダーでいつでも振り返ることができます。<br/>
      あさって以降のアラームはカレンダーから編集できます。
    </td>
    <td>
      <a href="https://gyazo.com/fbf54c2727654ec7c6b4fab9149ddaec"><img src="https://i.gyazo.com/fbf54c2727654ec7c6b4fab9149ddaec.gif" alt="Image from Gyazo" width="372"/></a>
      他のユーザーの起床情報を一覧で確認することができます（自身を非表示にすることも可能）。<br/>
      仲間の頑張りを見てモチベーションを上げましょう！
    </td>
  </tr>
  <tr>
    <th style="text-align: center">一週間の振り返りレポート</th>
  </tr>
  <tr>
    <td>
      <a href="https://gyazo.com/5c99a781fe6cb261791fe03eccc60197"><img src="https://i.gyazo.com/5c99a781fe6cb261791fe03eccc60197.png" alt="Image from Gyazo" width="508"/></a>
      毎週日曜の18時に、あなたの一週間の起床情報のレポートを送ります。
    </td>
  </tr>
</table>

## 機能一覧

- LINE ログイン
- お笑いの嗜好性（お笑いに関するタグ、キーワード、動画の長さ）設定機能
- アラーム機能
  起床後に、設定したアラーム時刻から 10 分間の間、嗜好性に基づいてレコメンドされたお笑い動画を視聴できる。
  動画の URL を添付することで、自身で選択することもできる。
  もし動画が気に入らなかったら、別の動画をレコメンドしてもらうことができる。
  同じ動画は二度表示されない（視聴しなかったものも含めて）。
- アラームの時刻に、LINE 公式アカウントからプッシュ通知を受け取ることができる機能
- 起床成功後に試聴した動画と試聴成功をポスト（ツイート）できる機能
- 自身が設定したアラームの情報をカレンダーで振り返ることができる機能
- 他のユーザーの起床成功情報を一覧で見れる機能（自身の表示は任意）
- LINE 上でアラーム登録やレコメンド動画視聴を完結できる機能
- 一週間の振り返りを LINE 通知する機能

## 今後実装予定の機能

- 本アプリの効果を実感できるような、お笑いや睡眠に関するコラムを定期的に送信する機能

## 使用技術一覧

**バックエンド:** Ruby 3.1.0 / Rails 7.0.8

- コード解析 / フォーマッター: Rubocop

**フロントエンド:** JavaScript / Hotwire

**CSS フレームワーク:** TailwindCSS / DaisyUI

**WebAPI:** LINE ログイン / LINE Messaging API / Youtube data API / Cloudinary

**インフラ:**

- Web アプリケーションサーバ: Render.com
- データベースサーバ: PostgreSQL (Render.com)
- バックグラウンドワーカー: Sidekiq (Render.com)
- キューストレージ: Redis (Render.com)

**VCS:** GitHub

## ER 図

[![Image from Gyazo](https://i.gyazo.com/004bf0655ab8b0290322e3b4635b5725.png)](https://gyazo.com/004bf0655ab8b0290322e3b4635b5725)

## 画面遷移図のリンク

https://www.figma.com/file/ZReC0nwGyNlWT20LhTTk2Q/graduation_exam-%E3%82%8F%E3%82%89%E3%81%84%E3%81%9A?type=design&node-id=0%3A1&mode=design&t=vJTmHqRe6zAULy6k-1
