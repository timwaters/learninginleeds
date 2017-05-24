ActiveAdmin.register Topic do


  permit_params :id, :name, :subject_ids => []

  form do | f| 

    f.inputs 'Details' do
      f.input :name
    end

    f.inputs do
      f.input :subjects, as: :check_boxes, collection: Subject.all.order(:description).map {|u| ["#{u.code.to_s} #{u.description}", u.id]} 
    end

    f.actions
  end

  sidebar "Subjects", only: :show do
    ul do
      resource.subjects.each do | u |
        li  link_to("#{u.code.to_s} #{u.description}", admin_subject_path(u)) 
      end
    end #ul
  end #sidebar

end

