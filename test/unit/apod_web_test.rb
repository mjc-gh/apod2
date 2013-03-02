require 'test_helper'
require_dependency 'gopher'

class ApodWebTest < ActiveSupport::TestCase
  INDEX_URI = 'http://apod.nasa.gov/apod/archivepix.html'
  VIEW_URI = 'http://apod.nasa.gov/apod/ap1234.html'

  test "index returns nokogiri doc" do
    FakeWeb.register_uri :get, INDEX_URI, body: '<html></html>'

    assert_kind_of Nokogiri::HTML::Document, ApodWeb.index
  end

  test "view returns nokogiri doc" do
    FakeWeb.register_uri :get, VIEW_URI, body: '<html></html>'

    assert_kind_of Nokogiri::HTML::Document, ApodWeb.view('ap1234')
  end

  #test "view with invalid UTF8" do
    #FakeWeb.register_uri :get, VIEW_URI, body: fixture_file('view_utf_2.html')
    #assert ApodWeb.view('ap1234').text =~ //
  #end
end
