class WebhooksController < ApplicationController
  require 'line/bot'
  include YoutubeApi
  skip_before_action :authenticate_user!
  protect_from_forgery except: :callback

  def callback
    client = Line::Bot::Client.new do |config|
      config.channel_id = ENV.fetch('LINE_MESSAGING_ID', nil)
      config.channel_secret = ENV.fetch('LINE_MESSAGING_SECRET', nil)
      config.channel_token = ENV.fetch('LINE_MESSAGING_TOKEN', nil)
    end

    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    return head :bad_request unless client.validate_signature(body, signature)

    events = client.parse_events_from(body)
    events.each do |event|
      message = case event
                when Line::Bot::Event::Message
                  { type: 'text', text: parse_message_type(event) }
                end
      client.reply_message(event['replyToken'], message) if message
    end
    head :ok
  end

  private

  def parse_message_type(event)
    case event.type
    when Line::Bot::Event::MessageType::Text
      reaction_text(event)
    else
      "アラームの時刻や起床報告等の、決まった文言のみ受け取ることができます。"
    end
  end

  def reaction_text(event)
    return "ユーザーが見つかりません。公式サイトからLINEログインをしてアカウントを登録してください。" unless user = User.find_by(uid: event['source']['userId'])

    if event.message['text'].scan(/\d{8}/).any?
      alarm_strings = event.message['text'].split("\n")
      alarms = []
      message = "以下のアラームを作成しました！\n\n"
      alarm_strings.each do |alarm_string|
        if alarm_string.match?(/^\d{8}$/)
          month = alarm_string[0..1].to_i
          day = alarm_string[2..3].to_i
          hour = alarm_string[4..5].to_i
          minute = alarm_string[6..7].to_i
          alarms << { wake_up_time: Time.zone.local(Time.current.year, month, day, hour, minute), custom_video_url: nil } if Date.valid_date?(Time.current.year, month, day) && hour.between?(0, 23) && minute.between?(0, 59)
        elsif alarm_string.include?("youtube.com") || alarm_string.include?("youtu.be")
          alarms.last[:custom_video_url] = alarm_string unless alarms.empty?
        end
      end
      if alarms.empty?
        "登録できませんでした。送信された数字が存在する時刻を表しているか確認してください。"
      else
        alarms.each do |alarm|
          new_alarm = Alarm.create!(wake_up_time: alarm[:wake_up_time], custom_video_url: alarm[:custom_video_url], user_id: user.id)
          job = SendNotificationJob.set(wait_until: new_alarm.wake_up_time).perform_later(new_alarm)
          new_alarm.update(job_id: job.provider_job_id)
          message += "#{l alarm[:wake_up_time], format: :short} #{alarm[:custom_video_url].present? ? '動画選択' : ''}\n"
        end
        message
      end

    elsif event.message['text'] == "今日、明日のアラーム"
      Alarm.set_false_to_is_successful(user)
      message = "今日のアラーム\n"
      today_alarms = Alarm.where(user_id: user.id, wake_up_time: Time.zone.now.all_day).order(:wake_up_time)
      tomorrow_alarms = Alarm.where(user_id: user.id, wake_up_time: Time.zone.tomorrow.all_day).order(:wake_up_time)
      if today_alarms.any?
        today_alarms.each do |today_alarm|
          is_successful = case today_alarm[:is_successful]
                          when true
                            '成功'
                          when false
                            '失敗'
                          else
                            ''
                          end
          message += "#{l today_alarm[:wake_up_time], format: :time} #{today_alarm[:custom_video_url].present? ? '動画選択' : ''} #{is_successful}\n"
        end
      else
        message += "なし\n"
      end
      message += "\n明日のアラーム\n"
      if tomorrow_alarms.any?
        tomorrow_alarms.each do |tomorrow_alarm|
          is_successful = case tomorrow_alarm[:is_successful]
                          when true
                            '成功'
                          when false
                            '失敗'
                          else
                            ''
                          end
          message += "#{l tomorrow_alarm[:wake_up_time], format: :time} #{tomorrow_alarm[:custom_video_url].present? ? '動画選択' : ''} #{is_successful}\n"
        end
      else
        message += "なし\n"
      end
      message

    elsif event.message['text'] == "起床"
      alarm = Alarm.where(wake_up_time: (10.minutes.ago)..Time.zone.now, user_id: user.id, is_successful: nil).order(wake_up_time: :desc).first
      if alarm
        item = alarm.custom_video_url.present? ? fetch_custom_video_item(alarm) : fetch_recommended_video_item(user)
        return "設定していただいた検索ワードと動画の時間でレコメンドできる動画が無くなりました。嗜好性を変更してください。" unless item

        binding.pry
        alarm.update!(is_recommended_on_line: true)
        user.viewed_videos.create!(video_id: item.id.video_id, thumbnail: item.snippet.thumbnails.high.url, title: item.snippet.title)
        "おはようございます！\n下記が本日の動画です。\nhttps://www.youtube.com/embed/#{item.id.video_id}\n動画を視聴後、「視聴完了」ボタンを押して下さい。\nもし他の動画が見たい場合は、「他の動画」ボタンを押して下さい。"

      else
        "10分前から現在時刻の間の時間で設定されたアラームがありません。"
      end

    elsif event.message['text'] == "他の動画"
      alarm = Alarm.where(is_recommended_on_line: true, is_successful: nil, user_id: user.id).order(wake_up_time: :desc).first # このコード要修正
      if alarm
        item = alarm.custom_video_url.present? ? fetch_custom_video_item(alarm) : fetch_recommended_video_item(user)
        return "設定していただいた検索ワードと動画の時間でレコメンドできる動画が無くなりました。嗜好性を変更してください。" unless item

        user.viewed_videos.create!(video_id: item.id.video_id, thumbnail: item.snippet.thumbnails.high.url, title: item.snippet.title)
        "https://www.youtube.com/embed/#{item.id.video_id}\n動画を視聴後、「視聴完了」ボタンを押して下さい。\nもし他の動画が見たい場合は、「他の動画」ボタンを押して下さい。"

      else
        "まだ今日の動画をレコメンドしていません。"
      end

    elsif event.message['text'] == "視聴完了"
      binding.pry
      alarm = Alarm.where(is_recommended_on_line: true, is_successful: nil, user_id: user.id).order(wake_up_time: :desc).first
      if alarm
        user.viewed_videos.last.update!(alarm_id: alarm.id)
        alarm.update!(is_successful: true)
        "おめでとうございます！\n起床情報が保存されました。\n忘れないうちに明日のアラームをセットしましょう！"
      else
        "まだ今日の動画をレコメンドしていません。"
      end

    elsif event.message['text'] == "アラーム作成" || event.message['text'] == "使い方"
      nil

    else
      "アラームの時刻や起床報告等の、決まった文言のみ受け取ることができます。"
    end
  end

  def fetch_custom_video_item(alarm)
    video_id = extract_video_id_from_url(alarm.custom_video_url)
    video_detail = fetch_video_detail(video_id)
    item = Struct.new(:id, :snippet)
    item = item.new(Struct.new(:video_id).new(video_id), Struct.new(:thumbnails, :title))
    item.snippet = item.snippet.new(Struct.new(:high).new(Struct.new(:url).new(video_detail.snippet.thumbnails.high.url)), video_detail.snippet.title)
    item
  end

  def fetch_recommended_video_item(user)
    query = user.set_query
    search_results = find_videos(query, user)
    filter_viewed_videos(search_results, user)
  end

  def extract_video_id_from_url(url)
    if url.include?("youtube.com")
      url.split("v=").last.split("&").first
    elsif url.include?("youtu.be")
      url.split("/").last.split("?").first
    end
  end

  def filter_viewed_videos(search_results, user)
    search_results.items.reject { |item| user.viewed_videos.pluck(:video_id).include?(item.id.video_id) }.first
  end
end
