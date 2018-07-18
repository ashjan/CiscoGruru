class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.string :slug
      t.text :brief_html
      t.text :brief_md
      t.text :content_html
      t.text :content_md
      t.boolean :is_sponsored
      t.boolean :is_published
      t.integer :view_count

      t.timestamps null: false
    end
  end
end
