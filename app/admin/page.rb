ActiveAdmin.register Page do
  permit_params :body, :name


  form do |f|
    f.inputs "" do
      f.input :name, input_html: { value: "about"}
      f.input :body
    end
  f.actions
  end
  
end