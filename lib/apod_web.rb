require 'nokogiri'
require 'httparty'

class ApodWeb
  include HTTParty

  base_uri 'http://apod.nasa.gov/apod'
  parser Proc.new { |body|
    Nokogiri::HTML.parse body, base_uri, 'iso-8859-1'
  }

  def self.index
    get '/archivepix.html'
  end

  def self.view(ident)
    get "/#{ident}.html"
  end
end
