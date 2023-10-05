class Upload < ApplicationRecord

  has_attached_file :image,
    :styles => {:micro => ["70x70>", :png], :thumbnail => ["450x250>", :png], :large => ["900x900>", :png]},
    :url => '/uploads/:id/:style/:basename.:extension',
    preserve_files: false,
    use_timestamp: false,
    presence: true,
    restricted_characters: /[&$+,\/:;=?@<>\[\]\{\}\)\(\'\"\|\\\^~%# ]/

  validates_attachment :image, presence: true, content_type: { content_type: ["image/jpg", "image/jpeg","image/pjpeg", "image/png","image/x-png", "image/gif"] }

end
