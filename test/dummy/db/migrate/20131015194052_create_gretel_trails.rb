class CreateGretelTrails < ActiveRecord::Migration
  def change
    create_table :gretel_trails do |t|
      t.string :key, limit: 40
      t.text :value
      t.datetime :expires_at
    end
    add_index :gretel_trails, :key, unique: true
    add_index :gretel_trails, :expires_at
  end
end
