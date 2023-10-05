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
      row "micro (70x70>)" do
        div do
          url_for t.image.url(:micro)
        end
        span do
          image_tag(t.image.url(:micro))
        end
      end
      row "thumbnail (450x250>)" do
        div do
          url_for t.image.url(:thumbnail)
        end
        span do
          image_tag(t.image.url(:thumbnail))
        end
      end
      row "large (900x900>)" do
        div do
          url_for t.image.url(:large)
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