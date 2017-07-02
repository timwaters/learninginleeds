ActiveAdmin.register Venue do
  permit_params :name, :postcode, :latitude, :longitude, :address_1, :address_2, :address_3


  controller do
     def update(options={}, &block)

      super do |success, failure| 
       
        success.html { 
         
          if resource.saved_changes["latitude"] || resource.saved_changes["longitude"]
            resource.courses.each do | course |
              course.latitude = resource.latitude
              course.longitude = resource.longitude
              course.lonlat = "POINT(#{resource.longitude} #{resource.latitude})" unless resource.longitude.nil?
              course.save
            end
          end

          redirect_to(admin_venue_path(:venue_id => resource.id))
         }
         
        failure.html { render :edit }
      end

     end
  end


  form do | f| 

    f.inputs do
      f.input :name
      f.input :address_1
      f.input :address_2
      f.input :address_3
      f.input :postcode
      f.input :latitude
      f.input :longitude
    end

    f.actions
  end

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