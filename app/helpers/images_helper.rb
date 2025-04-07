module ImagesHelper
  DEFAULT_OPTIONS = { format: "avif" }
  VIEW_OPTIONS = {
    "grayscale" => { saver: { colorspace: "Gray" } }
  }
  VARIANT_OPTIONS = {
    thumbnail: { resize_to_limit: [ 240, 240 ] },
    large: { resize_to_limit: [ 720, 720 ] }
  }

  def link_img(image, variant = :thumbnail)
    if image.file.representable?
      link_to img_variant_tag(image, variant), img_variant_url(image)
    end
  end

  def img_variant_tag(image, variant = :thumbnail)
    image_tag image.file.variant(**DEFAULT_OPTIONS, **variant_options(variant), **view_options), class: "img-fluid"
  end

  def img_variant_url(image, variant = nil)
    url_for(image.file.variant(**DEFAULT_OPTIONS, **variant_options(variant), **view_options))
  end

  private

  def view_options = VIEW_OPTIONS[cookies[:view]] || {}
  def variant_options(variant) = VARIANT_OPTIONS[variant] || {}
end
