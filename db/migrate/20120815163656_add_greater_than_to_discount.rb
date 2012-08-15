class AddGreaterThanToDiscount < ActiveRecord::Migration
  def change
    add_column :discounts, :greater_than, :integer
  end
end
