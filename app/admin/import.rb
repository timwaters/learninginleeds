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

  index do
    selectable_column
    id_column
    column :note
    column :status
    column :rows_num
    column :imported_num
    column "Errors?" do |import|
      import.error_log.present? && import.error_log.any?
    end
    column :upload_url
    column :csv_file_file_name
    column :created_at
    column :finished_at

    actions
  end





  show do
    attributes_table do
      row :status
      row :csv_file_file_name
      row "num of rows in csv" do | i |
        i.rows_num 
      end 
      row :imported_num

      row :note
      row "errors" do |import|
        if import.error_log.present? && import.error_log.any?
          true
        else
          false
        end
      end
      row :created_at
    end

    if import.error_log.present? && import.error_log.any?

      panel "Error Log" do
        div class: "attributes_table" do
          import.error_log.each do |entry|
            table class:"error_log" do
              entry = entry.stringify_keys 
              sorted_entry = entry.sort_by { |key, _| key == "message" ? 0 : 1 }
              sorted_entry.each do |key, value|
                tr do
                  th key.humanize
                  td value.presence || "-"
                end #tr
              end #k,v
            end # table
          end #entry
        end #div attributes_table
      end # panel

    end # if import log

  end #show
  

end
