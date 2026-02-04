class Video < ApplicationRecord
  validates :filename, :s3_key, :content_type, presence: true
end
