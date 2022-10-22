require 'csv'

namespace :gen_post_id_set_csv do
  desc 'generate csv'
  failures = []
  task :execute => :environment do
    p 'start'

    CSV.open("id_set.csv", "w", headers: ['kibela記事URL','Docbase記事URL','(短縮ver)Docbase記事URL'], write_headers: true) do |csv|
      Post.where.not(kibela_url: nil).find_each do |post|
        csv << [post.kibela_url, post.origin_url, post.origin_url.split('/').last]
      end
    end

    p 'completed'
  end
end
