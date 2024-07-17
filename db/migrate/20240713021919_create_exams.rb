class CreateExams < ActiveRecord::Migration[7.1]
  def change
    create_table :exams do |t|
      t.string :title, null: false, default: "그렙 코딩테스트"
      t.references :reserved_user, foreign_key: { to_table: :users, name: 'fk_exams_1' }, null: true
      t.timestamp :start_date_time, default: -> { 'NOW()' }
      t.timestamp :end_date_time, default: -> { 'NOW()' }
      t.integer :number_of_applicants, default: 10000
      t.string :status, default: 'requested'
      t.timestamps
    end
  end
end
