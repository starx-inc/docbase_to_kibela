namespace :rewrite_md_file_path do
  desc 'sync by kibela user'
  task :execute => :environment do
    without_match_files = []    
    p 'start'

    ActiveRecord::Base.transaction do
      AttachimentFile.preload(:post).find_each do |file|
        regexp = file_regexp(file.local_path.split('/').last)
        file.post.each do |post|
          unless regexp.macth?(post.body)
            without_match_files << [file.id, post.id]
            next
          end
          rewrite_post_body = post.body.gsub(regexp, replace_tag(post))
          post.update!(body: body)
        end
      end
    end

    p "without_match_files: #{without_match_files}"
    p 'complete'
  end

  private

  def file_regexp(file_id)
    /!\[.*\]\(https:\/\/image.docbase.io\/uploads\/#{file_id}.*?\)/
  end

  def replace_tag(file)
    "<img title='#{file.kibela_path}' alt='#{file.kibela_path}' src='#{file.kibela_path}' width='500' data-meta='{'width':500,'height':500}'>"
  end
end