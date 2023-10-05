ActiveAdmin.register Story do
  permit_params :body, :excerpt, :title, :visible, :thumbnail


  form do |f|
    f.inputs "" do
      f.input :visible, :label => "Visible?", :hint => "Show story in list and slider?"
      f.input :title, :label => "Title", hint: "Shown on slider, list and full story"
      f.input :thumbnail, :label => "URL to small image",  hint: "Shown on slider and list"
      f.input :excerpt, as: :simplemde_editor,  :label => "Excerpt", hint: "Markdown format. Shown for slider and list", :input_html => { :rows => 4, :class => 'excerpt', "data-options" => '{"status": true, "toolbarTips":true}'}
      f.input :body, as: :simplemde_editor,  :label => "Body" , hint: "Markdown format. Shown in full view"
    end
  f.actions
  end

  action_item :view, only: [:show, :edit] do
    link_to 'View on site', story
  end

  show do
    attributes_table do
      row :visible
      row :title
      row :thumbnail do |img|
        image_tag img.thumbnail
      end
      row :excerpt
      row :body
      row :created_at
      row :updated_at
    end
    span do
      link_to 'View this story on the site', story
    end
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
