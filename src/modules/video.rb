class Video
  # Takes a video hash from ytdl_host and transforms it into a readable object.
  def initialize(video_hash, event)
    @description = video_hash[:description] || 'N/A'
    @title = video_hash[:title] || 'N/A'
    @url = video_hash[:webpage_url] || 'N/A'
    @thumbnail_url = video_hash[:thumbnail] || Bot::HBOT.profile.avatar_url
    @like_count = video_hash[:like_count] || 'N/A'
    @dislike_count = video_hash[:dislike_count] || 'N/A'
    @view_count = video_hash[:view_count] || 'N/A'
    @length = video_hash[:duration] || 0
    @location = video_hash[:filename] + '.mp4'
    @loop = false
    @event = event
    @skipped_time = 0
    @filters = video_hash[:filters] || []
  end

  # Get the location of the video object, either ffmpeg-ed or not.
  def location
    if @filters.any?
      @location.sub('data/musiccache/', "data/musiccache/ffmpeg-#{filters.map(&:chr).join}-")
    else
      @location
    end
  end

  # Returns the base video object without any ffmpeg prefixes (if there are any).
  def base_location
    @location
  end

  # Returns the arguments to be passed into ffmpeg to apply the filters.
  def ffmpeg_arguments
    args = []
    @filters.each do |filter|
      args <<
        case filter
        when 'bass' then 'bass=g=25:f=50'
        when 'echo' then 'aecho=0.8:0.6:1000:0.8'
        when 'ftempo' then 'atempo=1.5'
        when 'stempo' then 'atempo=0.5'
        end
    end
    args.join(', ')
  end

  attr_reader :description
  attr_reader :title
  attr_reader :url
  attr_reader :thumbnail_url
  attr_reader :like_count
  attr_reader :dislike_count
  attr_reader :view_count
  attr_reader :length
  attr_accessor :loop
  attr_reader :event
  attr_accessor :skipped_time
  attr_accessor :downloader
  attr_accessor :filters
end
