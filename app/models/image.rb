class Image < ApplicationRecord
  FORMAT = "avif"

  has_one_attached :file do |attachable|
    attachable.variant :thumbnail, resize_to_fit: [240, 240], convert: FORMAT
    attachable.variant :large, resize_to_fit: [720, 720], convert: FORMAT
    attachable.variant :original, convert: FORMAT
  end
end
