namespace :check_duplicate_notes do
  failures = []
  task :execute => :environment do
    p 'start'
    notes = Note.all
    ActiveRecord::Base.transaction do
      Post.find_each do |post|
        duplicated_notes = duplicated_notes(post, notes)
        if duplicated_notes.size > 0
          post.update!(is_duplicated: true, duplicated_url: duplicated_notes.pluck(:url).join)
          next
        end
      end
    end

    private

    def duplicated_notes(post, notes)
      duplicated_notes = notes.select do |title|
        note.title.include? post.title
      end
      duplicated_notes
    end

    p 'completed'
  end
end
