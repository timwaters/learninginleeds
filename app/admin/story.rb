ActiveAdmin.register Story do
  permit_params :body, :excerpt, :title, :visible, :thumbnail


  form do |f|
    f.inputs "" do
      f.input :visible, :label => "Visible?", :hint => "Show story in list and slider?"
      f.input :title, :label => "Title", hint: "Shown on slider, list and full story"
      f.input :thumbnail, :label => "URL to small image",  hint: "Shown on slider and list"
      f.input :excerpt, as: :simplemde_editor, :label => "Excerpt", hint: "Markdown format. Shown for slider and list"
      f.input :body, as: :simplemde_editor,  :label => "Body" , hint: "Markdown format. Shown in full view"
    end
  f.actions
  end
  
  index do
    selectable_column
    id_column
    column :visible
    column :title
    column :excerpt
    column :thumbnail

    column :created_at
    column :updated_at
   

    actions
  end

end
