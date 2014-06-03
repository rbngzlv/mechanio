# encoding: utf-8

class ReceiptUploader < CarrierWave::Uploader::Base

  storage :file

  def store_dir
    "#{Rails.root}/private/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def cache_dir
    "system/tmp"
  end
end
