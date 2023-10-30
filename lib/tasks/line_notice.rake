namespace :line_notice do
  desc "LINEで通知メッセージを送信"
  task send_alarm: :environment do
    client = Line::Bot::Client.new do |config|
      config.channel_secret = ENV['LINE_MESSAGING_SECRET']
      config.channel_token = ENV['LINE_MESSAGING_TOKEN']
    end

    # UTC時間に9時間を加算して日本時間を取得
    current_time_jst = Time.current.utc + 9.hours

    alarms = Alarm.where(wake_up_time: current_time_jst.beginning_of_minute)
    alarms.each do |alarm|
      next unless alarm.user.uid # user.uidがnilや空の場合は次のループへ

      message = {
        type: 'text',
        text: "#{alarm.user.name}さん、おはようございます！\n設定したアラームの時刻となりました！\n公式ページURL\nhttps://warise-e5c75204d3f6.herokuapp.com/"
      }
      response = client.push_message(alarm.user.uid, message)
      p response
    end
  end
end
