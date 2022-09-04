namespace :rewrite_md_docbase_post_url do
  desc "rewrite md"
  task :execute => :environment do
    without_match_files = []    
    p "start"

    ActiveRecord::Base.transaction do
      Post.find_each do |post|
        update_contents = rewrited_contents(post)
        if update_contents.blank?
          without_match_files << post.id
          next
        end
        post.update!(body: update_contents)
      end
    end

    p "without_match_files: #{without_match_files.size} #{without_match_files}"
    p "complete"
  end

  private

  def rewrited_contents(post)
    if /https:\/\/starx.docbase.io\/posts\/#{post.id}/.match?(post.body)
      return post.body.gsub(/https:\/\/starx.docbase.io\/posts\/#{post.id}/, post.kibela_url)
    end

    if /\#\{#{post.id}\}/.match?(post.body)
      return post.body.gsub(/\#\{#{post.id}\}/, post.kibela_url)
    end

    return nil
  end
end
