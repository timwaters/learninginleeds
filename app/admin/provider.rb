ActiveAdmin.register Provider do
  permit_params :name, :url, :telephone, :email

  index do
    selectable_column
    column :id do | p |
      link_to p.id, admin_provider_path(p)
    end
    column :name do |p|
      link_to p.name, admin_provider_path(p)
    end
    column :url
    column :telephone
    column :email
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
