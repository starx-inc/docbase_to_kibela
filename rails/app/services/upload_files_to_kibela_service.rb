class UploadFilesToKibelaService
  def execute
    AttachimentFile.where(kibela_path: nil).find_each do |file|
      UploadFilesToKibelaJob.perform_in(1.second, file)
    end
  end
end
