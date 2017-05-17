ActiveAdmin.register Course do

  permit_params :title, :description, :target_group, :status, :qualification, :start_date, :end_date, :hours, :target_number, :enrolment_count, :academic_year

  #not permitted e.g. lcc_code, provider_code, provider_id, venue_id, subject_id 
end
