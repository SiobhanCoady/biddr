class AddDateColumnToBids < ActiveRecord::Migration[5.0]
  def change
    add_column :bids, :date, :datetime
  end
end
