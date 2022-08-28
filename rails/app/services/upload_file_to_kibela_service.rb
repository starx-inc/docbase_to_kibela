class UploadFileToKibelaService
  def execute
    AttachimentFile.where(kibela_path: nil).find_each do |file|
      UploadFileToKibelaJob.perform_in(1.second, file.id)
    end
  end
end
