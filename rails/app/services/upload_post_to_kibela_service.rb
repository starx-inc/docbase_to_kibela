class UploadPostToKibelaService
  def execute
    Post.where(is_duplicated: [false, nil]).find_each do |post|
      UploadPostToKibelaJob.perform_in(1.second, post.id)
    end
  end
end
