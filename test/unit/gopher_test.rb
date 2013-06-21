require 'test_helper'
require_dependency 'gopher'

class GopherTest < ActiveSupport::TestCase
  def fetch(file = 'view.html')
    ApodWeb.stubs(:view).returns html_parser(file)

    Gopher.create_picture id: 'ap123456', date: Date.new
  end

  setup do
    ApodWeb.stubs(:index).returns(html_parser('index.html'))
  end

  test "picture_index finds all" do
    assert_equal 809, Gopher.picture_index.size
  end

  test "picture_index objects include id" do
    assert_includes Gopher.picture_index.first, :id
  end

  test "picture_index objects include date" do
    assert_includes Gopher.picture_index.first, :date
  end

  test "picture_index with 5 missing" do
    Picture.create(date: Date.new(2012, 9, 29))

    assert_equal 5, Gopher.missing_pictures.size
  end

  test "picture_index without any missing" do
    Picture.create(date: Date.new(2012, 10, 4))

    assert_equal 0, Gopher.missing_pictures.size
  end

  test "picture_index has correct ordering" do
    Picture.create(date: Date.new(2012, 10, 1))

    dates  = Gopher.missing_pictures.map { |h| h[:date] }
    sorted = dates.sort

    assert_equal sorted, dates
  end

  test "create_pictures adds Picture record" do
    assert_difference('Picture.count') { fetch }
  end

  test "create_picture sets title" do
    picture = fetch

    assert_equal 'Introducing Comet ISON', picture.title
  end

  test "create_picture sets credit" do
    picture = fetch

    assert_match %r|<a href="[^"]+">[\w\s]+</a>|, picture.credit
  end

  test "create_picture sets explanation" do
    picture = fetch

    # seems a little silly
    assert_equal 16, picture.explanation.scan(%r[</a>]).size
  end

  test "create_picture sets media" do
    picture = fetch

    assert_equal "<img src=\"#{ApodWeb::base_uri}/image/1210/ison_rolando_960.jpg\">", picture.media
  end

  test "create_picture sets media_link" do
    picture = fetch

    assert_equal "#{ApodWeb::base_uri}/image/1210/ison_rolando_1600.jpg", picture.media_link
  end

  test "no B elements found" do
    Nokogiri::HTML::Document.any_instance.stubs(:css).returns(%w[])

    assert_nil fetch
  end

  test "no P elements found" do
    Nokogiri::HTML::Document.any_instance.stubs(:css).with('b').returns(%w[1])
    Nokogiri::HTML::Document.any_instance.stubs(:css).with('p').returns(%w[])

    assert_nil fetch
  end

  test "handles invalid UTF" do
    picture = fetch('view_utf_2.html')

    refute_nil picture
  end

  test "handles more invalid UTF" do
    picture = fetch('view_utf_3.html')

    refute_nil picture
  end

  test "create_picture returns existing picture" do
    original = Picture.create id: 'ap123456', date: Date.new
    picture = fetch

    assert_equal original.id, picture.id
  end

  test "does not create new Picture" do
    Picture.create id: 'ap123456', date: Date.new

    assert_no_difference('Picture.count') { fetch }
  end
end
