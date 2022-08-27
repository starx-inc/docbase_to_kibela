class UploadFileToKibelaJob
  include Sidekiq::Worker
  sidekiq_options queue: :default, retry: 3

  def perform(file)
    file.upload_to_kibela!
  rescue Kibela::ApiError => api_error
    if api_error.only_rate_limit?
      UploadFileToKibelaJob.perform_in(1800.second)
    else
      pp api_error
    end
  rescue => e
    p "file_id: #{file.id} #{e.inspect} error occurred"
  end
end
