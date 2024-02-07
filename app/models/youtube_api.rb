module YoutubeApi
  require 'google/apis/youtube_v3'
  require 'active_support/all'

  def find_videos(query, user, before: Time.zone.now)
    service = Google::Apis::YoutubeV3::YouTubeService.new
    service.key = ENV.fetch('YOUTUBE_API_KEY', nil)
    service.list_searches(
      :snippet,
      type: "video",
      q: query,
      max_results: 20,
      video_syndicated: true,
      video_embeddable: true,
      video_duration: user.video_length
    )
  end

  def fetch_video_detail(video_id)
    service = Google::Apis::YoutubeV3::YouTubeService.new
    service.key = ENV.fetch('YOUTUBE_API_KEY', nil)
    begin
      response = service.list_videos('snippet', id: video_id)
      response.items.first if response.items.any?
    rescue Google::Apis::Error => e
      Rails.logger.error("#{e.message}")
      nil
    end
  end
end
