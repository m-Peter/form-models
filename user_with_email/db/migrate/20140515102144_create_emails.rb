class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.string :address
      t.boolean :confirmed
      t.references :user, index: true

      t.timestamps
    end
  end
end
