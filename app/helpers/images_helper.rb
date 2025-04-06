module ImagesHelper
  DEFAULT_OPTIONS = { format: "avif" }

  def link_img(image, variant = :thumbnail)
    if image.file.representable?
      variant_options = case variant
      when :thumbnail then { resize_to_limit: [ 240, 240 ] }
      when :large then { resize_to_limit: [ 720, 720 ] }
      else {}
      end
      view_options = case cookies[:view]
      when "grayscale" then { saver: { colorspace: "Gray" } }
      else {}
      end
      link_to image_tag(
        image.file.variant(**DEFAULT_OPTIONS, **variant_options, **view_options), class: "img-fluid"
      ), image.file.variant(**DEFAULT_OPTIONS, **view_options)
    end
  end
end
