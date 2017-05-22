ActiveAdmin.register Venue do
  permit_params :name, :postcode, :area, :committee, :ward, :latitude, :longitude

  index do
    selectable_column
    column :id do | v |
      link_to v.id, admin_venue_path(v)
    end
    column :name do |v|
      link_to v.name, admin_venue_path(v)
    end
    column :postcode
    column :area
    column :ward 
    column :latitude
    column :longitude
    column :created_at
    column :updated_at
    actions
  end


  sidebar "Courses", only: :show do
    ul do
      resource.courses.each do | course |
        li  link_to(course.title, admin_course_path(course)) 
      end
    end #ul
  end #sidebar

end