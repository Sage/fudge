class CreateWatched< ActiveRecord::Migration
  def change
    create_table :watched do |t|
      t.references :repo
      t.string :branch
      t.string :build_status
    end
  end
end
