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

    binding.pry

    events = client.parse_events_from(body)
    events.each do |event|
      message = case event
                when Line::Bot::Event::Message
                  { type: 'text', text: parse_message_type(event) }
                else
                  "トークイベントちゃう"
                end
      binding.pry
      client.reply_message(event['replyToken'], message)
    end
    head :ok
  end

  private

  def parse_message_type(event)
    case event.type
    when Line::Bot::Event::MessageType::Text
      reaction_text(event)
    else
      "テキストメッセージちゃう"
    end
  end

  def reaction_text(event)
    if event.message['text'].scan(/\d{8}/).any?
      alarm_strings = event.message['text'].split("\n")
      alarms = []
      binding.pry
      alarm_strings.each do |alarm_string|
        binding.pry
        if alarm_string.match?(/^\d{8}$/)
          month = alarm_string[0..1].to_i
          day = alarm_string[2..3].to_i
          hour = alarm_string[4..5].to_i
          minute = alarm_string[6..7].to_i
          alarms << { wake_up_time: Time.zone.local(Time.current.year, month, day, hour, minute), custom_video_url: nil }
        elsif alarm_string.include?("youtube.com") || alarm_string.include?("youtu.be")
          alarms.last[:custom_video_url] = alarm_string unless alarms.empty?
        end
      end
      binding.pry
      alarms.each do |alarm|
        Alarm.create(wake_up_time: alarm[:wake_up_time], custom_video_url: alarm[:custom_video_url], user_id: User.find_by(uid: event['source']['userId']).id)
      end
      binding.pry
      "設定完了"
    else
      "アラーム設定用の文言ちゃう"
    end
  end
end
