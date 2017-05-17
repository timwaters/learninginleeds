ActiveAdmin.register Subject do
  permit_params :code, :description, :topic_ids => []

end
