class WebhooksController < ApplicationController
  require 'line/bot'
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

    Alarm.set_false_to_is_successful(user)

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
          binding.pry
          new_alarm = Alarm.create!(wake_up_time: alarm[:wake_up_time], custom_video_url: alarm[:custom_video_url], user_id: user.id)
          job = SendNotificationJob.set(wait_until: new_alarm.wake_up_time).perform_later(new_alarm)
          new_alarm.update(job_id: job.provider_job_id)
          message += "#{l alarm[:wake_up_time], format: :short} #{alarm[:custom_video_url].present? ? '動画選択' : ''}\n"
        end
        message
      end
    elsif event.message['text'] == "アラーム一覧"
      message = "今日のアラーム\n"
      binding.pry
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
    else
      "アラームの時刻や起床報告等の、決まった文言のみ受け取ることができます。"
    end
  end
end
