class AlarmsForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :user_id, :integer
  attribute :wake_up_time, :integer
  attribute :custom_video_url, :string

  def save
    return false unless valid?

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

  def update_diary
    return false unless valid?

    ActiveRecord::Base.transaction do # トランザクション内の処理が一つでも失敗すれば、ロールバックされます。
      entries_ids.each_with_index do |id, index| # 要素をループしながら、それぞれの要素が元の配列の何番目にあるかを簡単に知ることができます。
        entry = DiaryEntry.find(id)
        entry.update!(content: entries_contents[index])
      end
    end

    true
  rescue ActiveRecord::RecordInvalid
    false
  end

  private

  attr_reader :diary # 上記の@diaryインスタンス変数に読み取り専用でアクセスするために使うことができる。

  def default_attributes
    # @diaryインスタンス変数を直接参照するのではなく、
    # attr_readerで定義したdiaryメソッドを通して参照している
    {
      user_id: diary.user_id,
      entries_contents: diary.diary_entries.map(&:content),
      entries_ids: diary.diary_entries.map(&:id)
    }
  end

  def all_entries_must_be_present
    errors.add(:base, 'すべてのフォームに入力してください') if entries_contents.any?(&:blank?)
  end
end
