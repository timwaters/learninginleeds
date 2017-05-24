ActiveAdmin.register Subject do
  permit_params :code, :description, :topic_ids => []


  sidebar "Within Topics", only: :show do
    ul do
      resource.topics.each do | u |
        li  link_to(u.name, admin_topic_path(u)) 
      end
    end #ul
  end #sidebar

end
