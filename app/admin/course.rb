ActiveAdmin.register Course do

  permit_params :title, :description, :target_group, :status, :qualification, :start_date, :end_date, :hours, :target_number, :enrolment_count, :academic_year

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
