namespace :import_notes_from_kibela do
  desc 'import notes'
  failures = []
  task :execute => :environment do
    p 'start'
    not_exists = []
    notes = []
    has_next_page = true
    after = nil
    adapter = ::Kibela::Adapter.new

    p 'start request to kibela'
    while has_next_page do
      responses = adapter.get_notes(after)
      responses.data.notes.nodes.each do |note|
        notes << { title: note.title, url: note.url, created_at: Time.now, updated_at: Time.now }
      end
      has_next_page = responses.data.notes.to_h["pageInfo"]["hasNextPage"]
      after = responses.data.notes.to_h["pageInfo"]["endCursor"]
      sleep 5.second
    end
    p 'completed request to kibela'

    p 'execute insert_all!'
    ActiveRecord::Base.transaction do
      Note.insert_all!(notes)
    end
    p 'completed insert_all!'

    p 'completed'
  end
end
