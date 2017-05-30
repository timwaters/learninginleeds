namespace :courses do
  require 'csv'
  
  desc "reindexes full text for all courses"
  task reindex: :environment do
    puts "Reindexing records..."
    records_indexed = Course.fts_reindex
    puts "Record reindexed: #{records_indexed} "
  end
  
end
