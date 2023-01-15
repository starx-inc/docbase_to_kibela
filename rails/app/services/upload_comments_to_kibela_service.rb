class UploadCommentsToKibelaService
  def execute
    Comment.find_each do |comment|
      UploadCommentToKibelaJob.perform_in(1.second, comment.id)
    end
  end
end
