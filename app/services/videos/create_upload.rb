# app/services/videos/create_upload.rb
module Videos
  class CreateUpload
    def call(filename:, content_type:)
      Aws::S3PresignService.new.presign_upload(
        filename: filename,
        content_type: content_type
      )
    end
  end
end
