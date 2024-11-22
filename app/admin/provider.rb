ActiveAdmin.register Provider do
  permit_params :name, :url, :telephone, :email, :application_form, :visible, :body

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
    column :application_form
    column :visible
    column :body do | b |
      b.body[0..50] + " ..." if b.body
    end
    actions
  end

  form do |f|
  
    f.inputs do
      f.input :name
      f.input :url
      f.input :telephone
      f.input :email
      f.input :application_form, hint: "Should this provider use the LCC application form?"
      f.input :visible, :hint => "Should this provider be visible in the provider list?"
      f.input :body, as: :simplemde_editor,  :label => "Body" , hint: "Markdown format. Shown in provider list <br /> Headings: <br />Start with level 2 and above for accessibility. e.g. <br /> ## Level 2 Heading".html_safe
    end
    f.actions
  end


  sidebar "Courses", only: :show do
    ul do
      resource.courses.each do | course |
        li  link_to(course.title, admin_course_path(course)) 
      end
    end #ul
  end #sidebar


end
