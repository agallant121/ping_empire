class CreateResponses < ActiveRecord::Migration[8.0]
  def change
    create_table :responses do |t|
      t.references :website, null: false, foreign_key: true
      t.integer :status_code
      t.float :response_time
      t.datetime :checked_at

      t.timestamps
    end
  end
end
