ActiveAdmin.register Course do

  permit_params :title, :description, :target_group, :status, :qualification, :start_date, :end_date, :hours, :target_number, :enrolment_count, :academic_year


  
end
