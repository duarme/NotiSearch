class CreateSearches < ActiveRecord::Migration
  def self.up
    create_table :searches do |t|
      t.integer :user_id
      t.string  :keywords
      t.integer :category_id
      t.decimal :min_price
      t.decimal :max_price
      t.boolean :saved, default: false
      t.boolean :notify, default: false
      t.datetime :notified_at
      t.boolean :new_results_presence, default: false
      t.datetime :new_results_checked_at
      t.timestamps
    end
  end

  def self.down
    drop_table :searches
  end
end
