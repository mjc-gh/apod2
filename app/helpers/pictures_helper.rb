module PicturesHelper
  def nasa_url(pic_or_apid = nil)
    "http://apod.nasa.gov/apod/#{pic_or_apid.try(:apid) || pic_or_apid}"
  end
end
