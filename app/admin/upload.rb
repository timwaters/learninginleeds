ActiveAdmin.register Upload do

  permit_params :id, :image

  form do | f| 
    f.input :image, as: :file, required: true
    f.actions
  end

  index do
    selectable_column
    id_column
    column :filename do | t |
      t.image.original_filename
    end
    column :image do | t |
        image_tag(t.image.url(:micro))
    end
   
    actions
  end

  show do |t|
    attributes_table do
      row :image do
        image_tag(t.image.url(:thumbnail))
      end
   
      row "micro (100x100>)" do
        div do | i |
          text_field_tag :micro_url, t.image.url(:micro), size: 75, readonly: true
        end
        span do
          image_tag(t.image.url(:micro))
        end
      end
      row "thumbnail (450x250>)" do
        div do | i |
          text_field_tag :thumbnail_url, t.image.url(:thumbnail), size: 75, readonly: true
        end
        span do
          image_tag(t.image.url(:thumbnail))
        end
      end
      row "large (900x900>)" do

        div do | i |
          text_field_tag :large_url, t.image.url(:large), size: 75, readonly: true
        end
        span do
          image_tag(t.image.url(:large))
        end
      end
      row "original" do
        div do
          url_for t.image.url(:original)
        end
        span do
          image_tag(t.image.url(:original))
        end
      end
    
    end
  end

end