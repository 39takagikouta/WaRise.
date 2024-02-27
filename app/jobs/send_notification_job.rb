class SendNotificationJob < ApplicationJob
  queue_as :default

  def perform(alarm)
    client = Line::Bot::Client.new do |config|
      config.channel_secret = ENV.fetch('LINE_MESSAGING_SECRET', nil)
      config.channel_token = ENV.fetch('LINE_MESSAGING_TOKEN', nil)
    end

    message = {
      type: 'text',
      text: "#{alarm.user.name}さん、おはようございます！\n\n設定したアラームの時刻となりました！\n\n公式ページから動画を視聴してください\nhttps://wa-rise.com/"
    }
    response = client.push_message(alarm.user.uid, message)
    p response
  end
end
