class CreateFtsCoursesTable < ActiveRecord::Migration[5.1]
  def up
      execute 'CREATE VIRTUAL TABLE fts_courses USING fts3(title, description, soundex, tokenize=porter)'
  end
  
  def down
     drop_table :fts_courses
  end
end


