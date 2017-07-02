ActiveAdmin.register Venue do
  permit_params :name, :postcode, :area, :committee, :ward, :latitude, :longitude, :address_1, :address_2, :address_3

  index do
    selectable_column
    column :id do | v |
      link_to v.id, admin_venue_path(v)
    end
    column :name do |v|
      link_to v.name, admin_venue_path(v)
    end
    column :address_1
    column :address_2
    column :address_3
    column :postcode
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

ActiveAdmin.register_page "Venuemap" do
  content do
    render partial: 'venuemap'
  end
end