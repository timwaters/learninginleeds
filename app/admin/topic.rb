ActiveAdmin.register Topic do

  permit_params :id, :name, :filename, :icon, :category_1 => [], :category_2 => []

  form do | f| 

    f.inputs 'Details' do
      f.input :name
      f.input :icon, required: false, as: :file
    end

    f.inputs do
      f.input :category_1, as: :check_boxes, collection: Course.pluck(:category_1).uniq.map {|a| a.split(",")}.flatten.uniq.sort
      f.input :category_2, as: :check_boxes, collection: Course.pluck(:category_2).uniq.map {|a| a.split(",")}.flatten.uniq.sort
    end

    f.actions
  end


  show do |t|
    attributes_table do
      row :name
      row :icon do
        image_tag(t.icon.url(:thumb))
      end
      # Will display the image on show object page
  end
  end

end

