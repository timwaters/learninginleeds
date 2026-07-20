ActiveAdmin.register News do
  permit_params :body, :excerpt, :thumbnail, :title, :visible, :alt_text, :content, :header, :summary
  

  form html: { multipart: true } do |f|

    f.inputs "" do
      f.input :visible, :label => "Visible?", :hint => "Show news in list and slider?"
      f.input :title, :label => "Title", hint: "Shown on slider, list and full news"

      header_hint = if f.object.header.attached?
        image_tag(f.object.header.variant(:thumb))
      else
        content_tag(:span, "No image uploaded yet", class: "description")
      end

      f.input :header, as: :file, input_html: { accept: 'image/png, image/jpeg, image/jpg, image/webp' }, :label => "Header image",  hint: header_hint
      li "<p class='inline-hints'>Small banner image shown on slider and news list. Will be cropped automatically</p>".html_safe

      f.input :alt_text, :label => "Alt text for image",  hint: "Should describe what the image looks like"

      li "<strong>Summary</strong>".html_safe
      f.rich_text_area :summary, :label => "Summary", hint: "Excerpt. Shown for slider and list"
      li "<p class='inline-hints'>Excerpt. Shown for slider and list</p>".html_safe

      li "<strong>Content</strong>".html_safe
      f.rich_text_area :content, :label => "Content", hint: "Main content. Rich text format. Shown in full view"
      li "<p class='inline-hints'>Rich text format. Shown in full view</p>".html_safe
    end

    insert_tag Arbre::HTML::Details do
      insert_tag Arbre::HTML::Summary, "Show Older Fields"
      f.inputs class: "inputs optional-fields-group" do
        f.input :thumbnail, :label => "URL to small image. "
        f.input :excerpt, as: :simplemde_editor, :label => "Excerpt"
        f.input :body, as: :simplemde_editor,  :label => "Body" 
      end
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
      row :header do |img|
        image_tag img.header.variant(:thumb) if img.header.attached?
      end
      row :alt_text
      row :summary do |news|
        news.summary.body.to_s.html_safe
      end
      row :content do |news|
        news.content.body.to_s.html_safe
      end
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
    column :summary do |news|
      news.summary.body.to_s.html_safe
    end
    column :header do |img|
      image_tag img.header.variant(:thumb) if img.header.attached?
    end

    column :created_at
    column :updated_at
   

    actions
  end
end
