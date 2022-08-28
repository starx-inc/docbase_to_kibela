namespace :rewrite_md_file_path do
  desc "sync by kibela user"
  task :execute => :environment do
    without_match_files = []    
    p "start"

    ActiveRecord::Base.transaction do
      AttachimentFile.preload(:post).find_each do |file|
        file_extension = file.id.split(".").last
        regexp = file_regexp(file_extension, file.local_path.split("/").last)
        file.post.each do |post|
          unless regexp.match?(post.body)
            without_match_files << [file.id, post.id, regexp]
            next
          end
          rewrite_post_body = post.body.gsub(regexp, replace_contents(file_extension, file))
          post.update!(body: rewrite_post_body)
        end
      end
    end

    p "without_match_files: #{without_match_files.size} #{without_match_files}"
    p "complete"
  end

  private

  def file_regexp(file_extension, file_id)
    return /!\[.*\]\(https:\/\/image.docbase.io\/uploads\/#{file_id}.*?\)/ if is_img_file?(file_extension)
    /\[!\[.*\]\(https:\/\/docbase.io\/file_attachments\/#{file_id}.*?\)/
  end

  def replace_contents(file_extension, file)
    return file.drive_path if file.kibela_path.nil? && file.drive_path.present?
    return "<img title='#{file.kibela_path}' alt='#{file.kibela_path}' src='#{file.kibela_path}' width='500' data-meta='{width:500,height:500}'>" if is_img_file?(file_extension)
    "[#{file.kibela_path}.#{file_extension}](#{file.kibela_path})"
  end

  def is_img_file?(file_extension)
    image_extensions = %w(jpg jpeg png gif).freeze
    image_extensions.include? file_extension
  end
end
