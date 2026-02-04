# app/services/s3_presign_service.rb
require "aws-sdk-s3"

class S3PresignService
  def initialize
    @region = ENV.fetch("AWS_REGION")
    @bucket_name = ENV.fetch("S3_BUCKET")

    client = Aws::S3::Client.new(region: @region)
    @presigner = Aws::S3::Presigner.new(client: client)
  end

  # Upload
  def upload_url(filename:, content_type:)
    key = "uploads/#{SecureRandom.uuid}-#{filename}"

    url = @presigner.presigned_url(
      :put_object,
      bucket: @bucket_name,
      key: key,
      content_type: content_type,
      expires_in: 900
    )

    { upload_url: url, key: key }
  end

  # Stream (GET)
  def stream_url(key)
    @presigner.presigned_url(
      :get_object,
      bucket: @bucket_name,
      key: key,
      expires_in: 900,
      response_content_type: "video/mp4",
      response_content_disposition: "inline"
    )
  end
end
