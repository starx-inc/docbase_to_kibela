class UploadCommentToKibelaJob
  include Sidekiq::Worker
  sidekiq_options queue: :default, retry: false

  def perform(post_id)
    comment = Comment.find(post_id)
    comment.upload_to_kibela!
  rescue Kibela::ApiError => api_error
    if api_error.only_rate_limit?
      UploadCommentToKibelaJob.perform_in(1800.second)
    else
      pp api_error
    end
  end
end
