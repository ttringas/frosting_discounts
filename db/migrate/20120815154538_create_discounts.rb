class CreateDiscounts < ActiveRecord::Migration
  def change
    create_table :discounts do |t|
      t.string :code
      t.float :value
      t.integer :limit
      t.datetime :expiration

      t.timestamps
    end
  end
end
