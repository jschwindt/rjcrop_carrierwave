class User < ActiveRecord::Base
  mount_uploader :image, ImageUploader

  validates_integrity_of :image

  after_update :reprocess_image, :if => :cropping?

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  private
  def reprocess_image
    image.reprocess!(crop_x, crop_y, crop_w, crop_h)
    store_image!
    image.recreate_versions!
  end
end

