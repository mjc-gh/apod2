require 'test_helper'
require_dependency 'gopher'

class GopherTest < ActiveSupport::TestCase
  INDEX_URI = 'http://apod.nasa.gov/apod/archivepix.html'
  VIEW_URI = 'http://apod.nasa.gov/apod/ap1234.html'

  test "ApodWeb.index returns nokogiri doc" do
    FakeWeb.register_uri(:get, INDEX_URI, body: '<html></html>')
    index = ApodWeb.index

    assert index
    assert_kind_of Nokogiri::HTML::Document, index
  end

  test "ApodWeb.view returns nokogiri doc" do
    FakeWeb.register_uri(:get, VIEW_URI, body: '<html></html>')
    view = ApodWeb.view('ap1234')

    assert view
    assert_kind_of Nokogiri::HTML::Document, view
  end
end
