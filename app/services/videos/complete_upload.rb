# app/services/videos/complete_upload.rb
module Videos
  class CompleteUpload
    def call(filename:, s3_key:, content_type:)
      Video.create!(
        filename: filename,
        s3_key: s3_key,
        content_type: content_type,
        status: "uploaded"
      )
    end
  end
end
