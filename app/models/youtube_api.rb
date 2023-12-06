module YoutubeApi
  require 'google/apis/youtube_v3'
  require 'active_support/all'

  def find_videos(query, user, after: 5.years.ago, before: Time.zone.now)
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
end
