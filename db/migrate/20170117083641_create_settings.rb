class CreateSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :settings do |t|
      t.string  :trans_code
      t.string  :inst_no
      t.string  :term_no
      t.integer :counter_counter
      t.boolean :enable

      t.timestamps
    end
  end
end
