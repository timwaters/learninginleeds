ActiveAdmin.register Import do
  permit_params :csv_file, :filename, :note
  
   form do |f|
    f.inputs "Upload" do
      f.input :note
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
