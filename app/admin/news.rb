ActiveAdmin.register News do
  permit_params :body,  :excerpt, :title, :visible, :thumbnail, :alt_text
  

  form do |f|
    f.inputs "" do
      f.input :visible, :label => "Visible?", :hint => "Show news in list and slider?"
      f.input :title, :label => "Title", hint: "Shown on slider, list and full news"
      f.input :thumbnail, :label => "URL to small image. ",  hint: "500x250 dimensions. Shown on slider and list"
      f.input :alt_text, :label => "Alt text for image",  hint: "Should describe what the image looks like"
      f.input :excerpt, as: :simplemde_editor, :label => "Excerpt", hint: "Markdown format. Shown for slider and list"
      f.input :body, as: :simplemde_editor,  :label => "Body" , hint: "Markdown format. Shown in full view"
    end
  f.actions
  end

  action_item :view, only: [:show, :edit] do
    link_to 'View on site', news
  end

  show do
    attributes_table do
      row :visible
      row :title
      row :thumbnail do |img|
        image_tag img.thumbnail
      end
      row :alt_text
      row :excerpt
      row :body
      row :created_at
      row :updated_at
    end
    span do
      link_to 'View this news article on the site', news
    end
  end

  index do
    selectable_column
    id_column
    column :visible
    column :title
    column :excerpt
    column :thumbnail
    column :alt_text

    column :created_at
    column :updated_at
   

    actions
  end
end
