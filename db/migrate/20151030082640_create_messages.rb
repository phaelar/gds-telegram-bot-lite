class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :hashtag, index: true, foreign_key: true
      t.string :user
      t.string :text
      t.string :chat_id
      t.string :chat_title

      t.timestamps null: false
    end
  end
end
