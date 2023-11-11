class PreferenceForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :comedy_tag_ids, default: []
  attribute :before_split_keyword_names, :string
  attribute :video_length, :integer

  validate :unique_keyword_names

  def save(preference_form, user)
    return false unless valid?

    ActiveRecord::Base.transaction do

      user.reset_comedy_tags_and_keywords
      create_comedy_tags_for_user(user)
      create_keywords_for_user(user)
      user.update!(video_length: preference_form.video_length)

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

    def create_comedy_tags_for_user(user)
      comedy_tag_ids.reject(&:blank?).each do |tag_id|
        user.user_comedy_tags.create!(comedy_tag_id: tag_id)
      end
    end

    def create_keywords_for_user(user)
      before_split_keyword_names.split('、').each do |keyword_name|
        user.keywords.create!(name: keyword_name)
      end
    end
end
