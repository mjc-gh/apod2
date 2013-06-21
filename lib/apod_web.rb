require 'nokogiri'
require 'httparty'

class ApodWeb
  include HTTParty

  base_uri 'http://apod.nasa.gov/apod'
  parser Proc.new { |body|
    if body.encoding != Encoding::UTF_8
      body.encode! 'UTF-8', undef: :replace, replace: ''
    elsif !body.valid_encoding?
      body.encode! 'UTF-8', 'binary', undef: :replace, replace: ''
    end

    Nokogiri::HTML.parse body, base_uri
  }

  def self.index
    get '/archivepix.html'
  end

  def self.view(ident)
    get "/#{ident}.html"
  end
end
