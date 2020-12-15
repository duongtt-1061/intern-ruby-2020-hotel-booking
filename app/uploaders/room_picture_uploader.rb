class RoomPictureUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "app/assets/images"
  end

  def filename
    "#{random_str}.#{file.extension}" if original_filename.present?
  end

  private

  def random_str
    @random_str ||= SecureRandom.urlsafe_base64
  end
end
