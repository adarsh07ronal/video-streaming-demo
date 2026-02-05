# app/policies/video_policy.rb
class VideoPolicy
  def initialize(user, video)
    @user = user
    @video = video
  end

  def stream?
    video.status == "uploaded"
  end
end
