ActiveAdmin.register Topic do

  permit_params :id, :name, :filename, :icon,  :promotion, :category_1 => [], :category_2 => []

  form do | f| 

    f.inputs 'Details' do
      f.input :name
      f.input :icon, required: false, as: :file
    end

    f.inputs do
      f.input :category_1, as: :check_boxes, collection: (f.object.category_1 + Course.pluck(:category_1)).uniq.map {|a| a.split(",")}.flatten.uniq.sort
      f.input :category_2, as: :check_boxes, collection: (f.object.category_2 + Course.pluck(:category_2)).uniq.map {|a| a.split(",")}.flatten.uniq.sort
    end

    f.inputs 'Promotional Banner HTML' do
      f.para "Insert html for promotional banner. Only <h3><strong> <br> and <a> tags accepted. Leave blank for no banner"
      f.input :promotion, required: false, hint: "Example: <h3>Help Getting Access to Digital Technology</h3> If you are interested in getting help with digital technology there are over 50 places across the area that are part of the Online Centres Network. Leeds City Council Libraries are able to help you get online and are a great resource for those without basic online skills or those looking to improve their existing digital knowledge. <br> <a href='http://example.com'>Find a Getting Online Venue</a>"
     
    end

    f.actions
  end


  show do |t|
    attributes_table do
      row :name
      row :icon do
        image_tag(t.icon.url(:thumb), width:50)
      end
      row :category_1
      row :category_2
      # Will display the image on show object page
      row :promotion
    end
  end

  index do
    selectable_column
    id_column
    column :name
    column :icon do | t |
        image_tag(t.icon.url(:thumb), width:50)
      end
    column :category_1
    column :category_2
    column :promotion do | t |
      t.promotion.blank? ? "" : "yes"
    end
    actions
  end

end

