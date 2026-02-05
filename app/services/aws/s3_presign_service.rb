# app/services/aws/s3_presign_service.rb
require "aws-sdk-s3"
require "securerandom"

module Aws
  class S3PresignService
    EXPIRY = 15.minutes.to_i

    def initialize
      client = Aws::S3::Client.new(region: ENV.fetch("AWS_REGION"))
      @bucket = ENV.fetch("S3_BUCKET")
      @presigner = Aws::S3::Presigner.new(client: client)
    end

    def presign_upload(filename:, content_type:)
      key = "uploads/#{SecureRandom.uuid}-#{filename}"

      url = @presigner.presigned_url(
        :put_object,
        bucket: @bucket,
        key: key,
        content_type: content_type,
        expires_in: EXPIRY
      )

      { upload_url: url, key: key }
    end

    def presign_stream(key)
      @presigner.presigned_url(
        :get_object,
        bucket: @bucket,
        key: key,
        expires_in: EXPIRY,
        response_content_type: "video/mp4",
        response_content_disposition: "inline"
      )
    end
  end
end
