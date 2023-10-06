class Upload < ApplicationRecord

  has_attached_file :image,
    :styles => {:micro => ["100x100>", :png], :thumbnail => ["450x250>", :png], :large => ["900x900>", :png]},
  #  :url => '/uploads/:id/:style/:basename.:extension',
    url: "/uploads/:id/:style/:hash.:extension",
    hash_data: ":class/:attachment/:id/:style/:updated_at",
    hash_secret: AppConfig["upload_hash_secret"],
    preserve_files: false,
    use_timestamp: false,
    presence: true,
    restricted_characters: /[&$+,\/:;=?@<>\[\]\{\}\)\(\'\"\|\\\^~%# ]/

  validates_attachment :image, presence: true, content_type: { content_type: ["image/jpg", "image/jpeg","image/pjpeg", "image/png","image/x-png", "image/gif"] }

end
