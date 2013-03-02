require 'test_helper'

class PicturesHelperTest < ActionView::TestCase
  test "nasa_url with nil" do
    assert_equal "http://apod.nasa.gov/apod/", nasa_url
  end

  test "nasa_url with Picture" do
    assert_match %r[/ap120101.html$], nasa_url(Picture.new(date: Date.new(2012,1,1)))
  end

  test "nasa_url with String" do
    assert_match %r[/ap120101.html$], nasa_url('ap120101')
  end
end
