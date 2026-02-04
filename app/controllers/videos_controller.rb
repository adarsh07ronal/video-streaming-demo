class VideosController < ApplicationController
  def presign
    service = S3PresignService.new

    result = service.upload_url(
      filename: params[:filename],
      content_type: params[:content_type]
    )

    render json: result
  end

  def complete
    video = Video.create!(
      filename: params[:filename],
      s3_key: params[:s3_key],
      content_type: params[:content_type],
      status: "uploaded"
    )

    render json: {
      message: "Video metadata saved",
      video_id: video.id
    }
  end
  # app/controllers/videos_controller.rb
  def stream
    video = Video.find(params[:id])

    url = S3PresignService.new.stream_url(video.s3_key)

    render json: { stream_url: url }
  end

end
