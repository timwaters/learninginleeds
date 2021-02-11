class AddShowApplicationFormToProviders < ActiveRecord::Migration[5.2]
  def change
    add_column :providers, :application_form, :boolean, default: true 
  end
end
