module YoutubeApi
  require 'google/apis/youtube_v3'
  require 'active_support/all'

  def find_videos(query, after: 4.years.ago, before: Time.zone.now)
    service = Google::Apis::YoutubeV3::YouTubeService.new
    service.key = Rails.application.credentials.youtube[:api_key]
    service.list_searches(
      :snippet,
      type: "video",
      q: query,
      max_results: 1,
      video_syndicated: true,
      video_embeddable: true,
      video_duration: "long"
    )
  end
end
