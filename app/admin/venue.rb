ActiveAdmin.register Venue do
  permit_params :name, :postcode, :area, :committee, :ward, :latitude, :longitude

end
