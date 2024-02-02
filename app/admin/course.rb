ActiveAdmin.register Course do

  permit_params :title, :description, :category_1, :category_2, :lonlat, :venue_id, :provider_id, :description_rtf

  before_save do | course |
    course.description_html = course.convert_description
  end

  form do | f| 

    f.inputs do
      f.input :title
      f.input :description
      f.input :description_rtf
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
    column :view_on_site do | c |
      link_to "View on site", course_path(c.lcc_code)
    end
    column :title
    column :description do | c |
        c.description[0...50] + "..." unless c.description.blank?
      end
      column :description_rtf do | c |
          c.description_rtf[0...50] + "..."  if c.description_rtf
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
