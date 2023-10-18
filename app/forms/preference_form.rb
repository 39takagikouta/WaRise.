class PreferenceForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :comedy_tag_ids, default: []
  attribute :before_split_keyword_names, :string
  attribute :min_video_length_minutes, :integer
  attribute :min_video_length_seconds, :integer
  attribute :max_video_length_minutes, :integer
  attribute :max_video_length_seconds, :integer

  validate :unique_keyword_names
  validate :min_video_length_less_than_max_video_length

  def save(preference_form, user)
    return false unless valid?
    adjust_video_lengths

    ActiveRecord::Base.transaction do

      user.user_comedy_tags.destroy_all
      preference_form.comedy_tag_ids.reject(&:blank?).each do |tag_id|
        user.user_comedy_tags.create!(comedy_tag_id: tag_id)
      end

      user.keywords.destroy_all
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
    errors.add(:base, "データの保存に失敗しました。これは予想していないエラーなので、発生した場合はお手数ですがお問合せいただけるとありがたいです。申し訳ありません。")
    false
  end

  private

  def unique_keyword_names
    keywords = before_split_keyword_names.split('、')
    if keywords.uniq.length != keywords.length
      errors.add(:base, "キーワードに重複があります。")
    end
  end

  def min_video_length_less_than_max_video_length
    min_video_length = (min_video_length_minutes.to_i * 60) + min_video_length_seconds.to_i
    max_video_length = (max_video_length_minutes.to_i * 60) + max_video_length_seconds.to_i
    if min_video_length > max_video_length
      errors.add(:base, "最短動画時間は最長動画時間より短くしてください。")
    end
  end

  def adjust_video_lengths
    self.min_video_length_minutes ||= 0
    self.min_video_length_seconds ||= 0
    self.max_video_length_minutes ||= 60
    self.max_video_length_seconds ||= 0

    if max_video_length_minutes == 0 && max_video_length_seconds == 0
      self.max_video_length_minutes = 60
    end
  end

end
