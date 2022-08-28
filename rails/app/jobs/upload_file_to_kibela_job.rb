class UploadFileToKibelaJob
  include Sidekiq::Worker
  sidekiq_options queue: :default, retry: 3

  def perform(file_id)
    file = AttachimentFile.find(file_id)
    file.upload_to_kibela!
  rescue Kibela::ApiError => api_error
    if api_error.only_rate_limit?
      p "rate_limit is over"
      UploadFileToKibelaJob.perform_in(1800.second, file_id)
    else
      p "other api error occurred"
      pp api_error
    end
  rescue => e
    p "file: #{file_id} #{e.inspect} error occurred"
  end
end
