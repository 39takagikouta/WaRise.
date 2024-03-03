class SendWeeklyReportJob < ApplicationJob
  queue_as :default

  def perform(*args)
    User.find_each do |user|
      send_weekly_report(user)
    end
  end

  private

  def send_weekly_report(user)
    start_date = Time.zone.today - 6.days
    end_date = Time.zone.today
    week = ["日", "月", "火", "水", "木", "金", "土"]
    message = "今週もお疲れ様でした！\n以下が今週の起床情報です。\n\n"

    (start_date..end_date).each_with_index do |date, index|
      message += "#{"\n" if index != 0}#{week[date.wday]}\n"
      alarms = user.alarms.where(wake_up_time: date.all_day)

      if alarms.any?
        alarms.each do |alarm|
          is_successful = case alarm[:is_successful]
                          when true
                            '成功'
                          when false
                            '失敗'
                          else
                            ''
                          end
          message += "#{alarm[:wake_up_time].strftime('%H:%M')} #{is_successful}\n"
        end
      else
        message += "なし\n"
      end
    end
    message.chomp!
    message += "\n\n以上です。\n来週も本アプリで朝を楽しみましょう！"

    send_line_message(user, message)
  end

  def send_line_message(user, message)
    client = Line::Bot::Client.new do |config|
      config.channel_secret = ENV.fetch('LINE_MESSAGING_SECRET', nil)
      config.channel_token = ENV.fetch('LINE_MESSAGING_TOKEN', nil)
    end

    message = {
      type: 'text',
      text: message
    }

    response = client.push_message(user.uid, message)
    p response
  end
end
