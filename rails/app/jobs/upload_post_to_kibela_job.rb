class UploadPostToKibelaJob
  include Sidekiq::Worker
  sidekiq_options queue: :default, retry: 3

  def perform
    target = AttachimentFile.where(kibela_id: nil).first
    target.upload_to_kibela!
    UploadPostToKibelaJob.perform_in(1.second)
  rescue Kibela::ApiError => api_error
    if api_error.only_rate_limit?
      UploadPostToKibelaJob.perform_in(1800.second)
    else
      pp api_error
    end
  end
end
