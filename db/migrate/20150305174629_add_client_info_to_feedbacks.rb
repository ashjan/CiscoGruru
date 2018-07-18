class AddClientInfoToFeedbacks < ActiveRecord::Migration
  def change
    add_column :feedbacks, :client_info, :text
  end
end
