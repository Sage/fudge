class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :uid
      t.string :token
      t.string :email
      t.boolean :admin
    end
  end
end
