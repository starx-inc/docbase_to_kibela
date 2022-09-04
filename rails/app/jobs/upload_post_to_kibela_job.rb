class UploadPostToKibelaJob
  include Sidekiq::Worker
  sidekiq_options queue: :default, retry: 3

  def perform(post_id)
    post = Post.find(post_id)
    post.upload_to_kibela!
  rescue Kibela::ApiError => api_error
    if api_error.only_rate_limit?
      UploadPostToKibelaJob.perform_in(1800.second)
    else
      pp api_error
    end
  end
end
