class CreateBusinessCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :business_categories do |t|
      t.string :prefix
      t.integer :number
      t.string :name
      t.string :queue_number
    end
  end
end
