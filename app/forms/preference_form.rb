class PreferenceForm
  include ActiveModel::Model      # モデルの機能を利用するために記載
  include ActiveModel::Attributes # モデルの機能を利用するために記載

  # 属性の定義
  attribute :min_video_length, :integer
  attribute :max_video_length, :integer
  attribute :user_id, :bigint
  attribute :comedy_tag_id, :bigint
  attribute :name, :string

  # バリデーション
  validates :min_video_length, presence: true
  validates :max_video_length, presence: true
  validates :user_id, presence: true
  validates :comedy_tag_id, presence: true #外部キーのattributeとvalidationいるんか知らんけど一応入れてる
  validates :comedy_tag_ids, length: { minimum: 5, message: '最低5つ選んでください' }

  def save
    return false unless valid?

    ActiveRecord::Base.transaction do
      #タグを保存する処理
      @user.user_comedy_tags.destroy_all
      comedy_tag_ids.each do |tag_id|
        @user.user_comedy_tags.create!(user_id: @user.id, comedy_tag_id: tag_id)
      end

      # フォームに記述された内容を、で区切ってKeywordsテーブルに保存
      @user.keywords.destroy_all
      keyword_names.split('、').each do |name|
        @user.keywords.create!(user_id: @user.id, name: name.strip)
      end

      # Usersテーブルのmin_video_lengthカラムとmax_video_lengthカラムに情報を保存
      @user.update!(min_video_length: min_video_length, max_video_length: max_video_length)
    end
    true
  rescue => e
    errors.add(:base, "保存に失敗しました: #{e.message}")
    false
  end

end
