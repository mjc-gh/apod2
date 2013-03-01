module PicturesHelper
  def nasa_url(apid = nil)
    base_url = "http://apod.nasa.gov/apod/"

    case apid
    when nil, '' then base_url
    when Picture then "#{base_url}#{apid.apid}.html"
    else "#{base_url}#{apid}.html"
    end
  end
end
