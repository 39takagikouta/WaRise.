# app/controllers/hoges_controller.rb
class HogesController < ApplicationController
  skip_before_action :authenticate_user!
  protect_from_forgery except: :callback

  OMAJINAI = /アブラカタブラ|チチンプイプイ|ヒラケゴマ/

  def callback
    client = Line::Bot::Client.new do |config|
      config.channel_id = ENV.fetch('LINE_MESSAGING_ID', nil)
      config.channel_secret = ENV.fetch('LINE_MESSAGING_SECRET', nil)
      config.channel_token = ENV.fetch('LINE_MESSAGING_TOKEN', nil)
    end

    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    return head :bad_request unless client.validate_signature(body, signature)

    # もし「起床」ときたら
      # もし所有者が「起床」を送ってきたユーザーであり、またwake_up_timeが現在時刻から10分以内であるalarmがあれば、
        # もしitemに動画がなければ
          # '申し訳ありません。設定していただいた検索ワードと動画の時間でレコメンドできる動画が無くなりました。検索ワードか時間、またはその両方を変更してください。'を表示する
        # そうでなければ
          # recommendアクションと同様の処理
          # ののち動画を送信。
      # そうでなければ
        # 「現在のアラームがありません」の文言を送信
    # もし「別の動画」ときたら
      # 「別の動画」ときたらvieviodeos#createアクションの別の動画を表示する部分の処理を実行（動画の情報を引き継げるのか？）
      # そして新しい動画を送信
    # もし、「視聴完了」とメッセージが入っていたら
      # vieviodeos#createアクションと同様の動作を行い、（動画の情報を引き継げるのか？）
      # 保存完了をメッセージで送信する
      # もし「視聴完了」の前に文章があれば
        # それをコメントとして保存する

    events = client.parse_events_from(body)
    events.each do |event|
      message = case event
                when Line::Bot::Event::Message
                  { type: 'text', text: parse_message_type(event) }
                else
                  { type: 'text', text: '........' }
                end
      client.reply_message(event['replyToken'], message)
    end
    head :ok
  end

  private

    def parse_message_type(event)
      case event.type
      when Line::Bot::Event::MessageType::Text
        reaction_text(event)   # ユーザーが投稿したものがテキストメッセージだった場合に返す値
      else
        'Thanks!!'             # ユーザーが投稿したものがテキストメッセージ以外だった場合に返す値
      end
    end

    def reaction_text(event)
      if event.message['text'].match?(OMAJINAI)
        'It is Omajinai'                          # 定数OMAJINAIに含まれる文字列の内、いずれかに一致した投稿がされた場合に返す値
      elsif event.message['text'].match?('ruby')
        'Is it Programming language? Ore?'        # `ruby`という文字列が投稿された場合に返す値
      else
        event.message['text']                     # 上記２つに合致しない投稿だった場合、投稿と同じ文字列を返す
      end
    end
end
