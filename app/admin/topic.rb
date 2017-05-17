ActiveAdmin.register Topic do


  permit_params :name, :subject_ids => []
 
  form do | f| 
    f.inputs 'Details' do
      f.input :name
    end
    f.inputs do
      f.has_many :subjects, heading: 'Themes', allow_destroy: false, new_record: true do |a|
        a.input :code
      end
    end
     f.actions
  end

end
