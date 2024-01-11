namespace :line_notice do
  desc "LINEで通知メッセージを送信"
  task send_alarm: :environment do
    client = Line::Bot::Client.new do |config|
      config.channel_secret = ENV.fetch('LINE_MESSAGING_SECRET', nil)
      config.channel_token = ENV.fetch('LINE_MESSAGING_TOKEN', nil)
    end

    alarms = Alarm.where(wake_up_time: Time.zone.now.beginning_of_minute)
    alarms.each do |alarm|
      next unless alarm.user.uid # user.uidがnilや空の場合は次のループへ

      message = {
        type: 'text',
        text: "#{alarm.user.name}さん、おはようございます！\n設定したアラームの時刻となりました！\n「起床」と本アカウントに送信するか、公式ページから動画を視聴してください\n公式ページURL\nhttps://wa-rise.com/"
      }
      response = client.push_message(alarm.user.uid, message)
      p response
    end
  end
end
