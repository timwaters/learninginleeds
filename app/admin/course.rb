ActiveAdmin.register Course do

  permit_params :title, :description, :category_1, :category_2, :lonlat, :venue_id, :provider_id

  form do | f| 

    f.inputs do
      f.input :title
      f.input :description
      f.input :category_1
      f.input :category_2
      f.input :lonlat
      f.input :venue
      f.input :provider
    end

    f.actions
  end

  index do
    selectable_column
    id_column
    column :lcc_code do | c |
      link_to c.lcc_code, admin_course_path(c)
    end
    column :title
    column :description do | c |
        c.description[0...50] + "..."
      end
    column :start_date
    column :end_date
    column :start_time
    column :end_time

    column :category_1
    column :category_2
    column :created_at
    column :updated_at

    actions
  end
  
end
