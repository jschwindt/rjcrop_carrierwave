# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  THUMB_W = 80
  THUMB_H = 60

  # Include RMagick or ImageScience support:
  include CarrierWave::RMagick
  # include CarrierWave::ImageScience

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :s3

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  version :normal do
    process :resize_to_limit => [250, 250]
  end

  version :thumb do
    process :resize_to_limit => [THUMB_W, THUMB_H]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # def filename
  #   "something.jpg" if original_filename
  # end

  def reprocess!(x,y,w,h)
    manipulate! do |img|
      img.crop(x.to_i, y.to_i, w.to_i, h.to_i, true) 
    end
  end

  def geometry
    image = ::Magick::Image.read(current_path)
    @geometry ||= {
      :width  => image.first.columns,
      :height => image.first.rows
    }
  end

  def width(version = :original)
    geometry[:width]
  end

  def height(version = :original)
    geometry[:height]
  end

end
