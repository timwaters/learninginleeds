ActiveAdmin.register Topic do

  permit_params :id, :name, :category_1 => [], :category_2 => []

  form do | f| 

    f.inputs 'Details' do
      f.input :name
    end

    f.inputs do
      f.input :category_1, as: :check_boxes, collection: Course.pluck(:category_1).uniq.map {|a| a.split(",")}.flatten.uniq.sort
      f.input :category_2, as: :check_boxes, collection: Course.pluck(:category_2).uniq.map {|a| a.split(",")}.flatten.uniq.sort
    end

    f.actions
  end

end

