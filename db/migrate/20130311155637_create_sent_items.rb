class CreateSentItems < ActiveRecord::Migration
  def change
    create_table :sent_items do |t|
      t.string :item_id
      t.string :to

      t.timestamps
    end
  end
end
