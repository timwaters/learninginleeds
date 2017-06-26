ActiveAdmin.register Import do
  permit_params :csv_file, :filename, :note, :upload_url
  
   form do |f|
    f.inputs "Upload" do
      f.input :note, :label => "Any notes about this import", :input_html => { :class => 'autogrow', :rows => 5 } 
      f.input :upload_url, :label => "URL for CSV File", :input_html => { :value=> AppConfig["csv_upload_url"]} 
      f.input :csv_file, required: true, as: :file
    end
    f.actions
  end

  member_action :run_import, method: [:get, :post] do
    resource.run_import!
    redirect_to resource_path, notice: "Imported!"
  end

  action_item :view, only: :show do
    link_to 'Run Import!', run_import_admin_import_path(import) if import.status == "ready"
  end

end
