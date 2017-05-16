class CreateJoinTableTopicSubject < ActiveRecord::Migration[5.1]
  def change
     create_table :subjects_topics, id: false do |t|
      t.belongs_to :topic, index: true
      t.belongs_to :subject, index: true
    end
  end
end
