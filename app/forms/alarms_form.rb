class AlarmsForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :user_id, :integer
  attribute :wake_up_times, default: []
  attribute :custom_video_urls, default: []

  def save(alarms, user)
    ActiveRecord::Base.transaction do # トランザクション内の処理が一つでも失敗すれば、ロールバックされます。
      diary = Diary.create!(user_id:, date: Time.current.to_date)
      entries_contents.each do |content|
        diary.diary_entries.create!(content:)
      end
    end
  rescue ActiveRecord::RecordInvalid => e # 処理が失敗した時の処理を書く
    e.record.errors.full_messages.each do |message|
      errors.add(:base, message)
    end
    false
  end

end
