class ListingImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  version :preview do
    process resize_to_fill: [280, 210]
  end

  def default_url(*args)
    [version_name, "default.jpg"].compact.join('_')
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  after :remove, :delete_empty_upstream_dirs

  def delete_empty_upstream_dirs
    path = ::File.expand_path(store_dir, root)
    Dir.delete(path)
  rescue SystemCallError
    true
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
