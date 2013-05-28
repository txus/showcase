class CreateFollowings < ActiveRecord::Migration
  def change
    create_table :followings do |t|
      t.integer :from_id
      t.integer :to_id
    end
  end
end
