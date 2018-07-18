class AddAnsweredToFeedbacks < ActiveRecord::Migration
  def change
    add_column :feedbacks, :answered, :boolean, default: false
  end
end
