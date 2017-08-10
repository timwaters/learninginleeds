ActiveAdmin.register Page do
  permit_params :body, :name


  form do |f|
    f.inputs "" do
      f.input :name, input_html: { placeholder: "about / welcome"}
      f.input :body
    end
  f.actions
  end
  
end
