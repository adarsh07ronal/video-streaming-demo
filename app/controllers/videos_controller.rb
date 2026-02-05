class VideosController < ApplicationController
  before_action :authenticate_user!

  def presign
    result = Videos::CreateUpload.new.call(
      filename: params[:filename],
      content_type: params[:content_type]
    )

    render json: result
  end

  def complete
    video = Videos::CompleteUpload.new.call(
      filename: params[:filename],
      s3_key: params[:s3_key],
      content_type: params[:content_type]
    )

    render json: { video_id: video.id }
  end

  def stream
    video = Video.find(params[:id])
    authorize video

    url = Videos::StreamVideo.new.call(video)

    render json: { stream_url: url }
  end
end
