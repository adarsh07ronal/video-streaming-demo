# app/services/videos/stream_video.rb
module Videos
  class StreamVideo
    def call(video)
      Aws::S3PresignService.new.presign_stream(video.s3_key)
    end
  end
end
