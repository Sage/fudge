class CreateRepos< ActiveRecord::Migration
  def change
    create_table :repos do |t|
      t.string :uri
      t.string :name
    end
  end
end
