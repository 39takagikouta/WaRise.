class PreferenceForm
  include ActiveModel::Model      # モデルの機能を利用するために記載
  include ActiveModel::Attributes # モデルの機能を利用するために記載

  # 属性の定義

  attribute :comedy_tag_ids, default: []
  attribute :before_split_keyword_names, :string
  attribute :min_video_length_minutes, :integer
  attribute :min_video_length_seconds, :integer
  attribute :max_video_length_minutes, :integer
  attribute :max_video_length_seconds, :integer

  def save(preference_form, user)
    return false unless valid?

    ActiveRecord::Base.transaction do
      #タグを保存する処理
      user.user_comedy_tags.destroy_all
      preference_form.comedy_tag_ids.reject(&:blank?).each do |tag_id|
        user.user_comedy_tags.create!(comedy_tag_id: tag_id)
      end

      # フォームに記述された内容を、で区切ってKeywordsテーブルに保存
      user.keywords.destroy_all
      preference_form.before_split_keyword_names.split('、').each do |keyword_name|
        user.keywords.create!(name: keyword_name)
      end

      # Usersテーブルのmin_video_lengthカラムとmax_video_lengthカラムに情報を保存
      user.update!(
        min_video_length: preference_form.min_video_length_minutes.to_i * 60 + preference_form.min_video_length_seconds.to_i,
        max_video_length: preference_form.max_video_length_minutes.to_i * 60 + preference_form.max_video_length_seconds.to_i
      )
    end
    true
  rescue => e
    puts "エラー: #{e.message}"
    puts e.backtrace  # スタックトレースも表示する場合
    false
  end

end
