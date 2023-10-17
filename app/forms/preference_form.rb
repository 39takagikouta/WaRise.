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

      user.user_comedy_tags.destroy_all
      preference_form.comedy_tag_ids.reject(&:blank?).each do |tag_id|
        user.user_comedy_tags.create!(comedy_tag_id: tag_id)
      end

      user.keywords.destroy_all
      binding.pry
      preference_form.before_split_keyword_names.split('、').each do |keyword_name|
        user.keywords.create!(name: keyword_name)
      end

      user.update!(
        min_video_length: preference_form.min_video_length_minutes.to_i * 60 + preference_form.min_video_length_seconds.to_i,
        max_video_length: preference_form.max_video_length_minutes.to_i * 60 + preference_form.max_video_length_seconds.to_i
      )
    end
    true
  rescue => e
    binding.pry
    errors.add(:base, "データの保存に失敗しました。これは予想していないエラーなので、発生した場合はお手数ですがお問合せいただけるとありがたいです。申し訳ありません。")
    false
  end

end
