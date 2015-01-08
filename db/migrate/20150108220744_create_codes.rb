class CreateCodes < ActiveRecord::Migration
  def change
    create_table :codes do |t|
      t.boolean :partial, default: false
      t.text :content

      t.timestamps
    end
  end
end
