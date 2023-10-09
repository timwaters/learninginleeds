ActiveAdmin.register Page do
  permit_params :body, :name


  form do |f|
    f.inputs "" do
      f.input :name, input_html: { placeholder: "about / welcome"}
      f.input :body, as: :simplemde_editor,  :label => "Body", hint: "Markdown format."
    end
  f.actions
  end
  
end
