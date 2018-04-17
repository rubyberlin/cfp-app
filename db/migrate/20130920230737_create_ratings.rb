class CreateRatings < ActiveRecord::Migration[5.0]
  def change
    create_table :ratings do |t|
      t.references :proposal, index: true
      t.references :user, index: true
      t.integer :score

      t.timestamps null: true
    end
  end
end
