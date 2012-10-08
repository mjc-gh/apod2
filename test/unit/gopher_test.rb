require 'test_helper'
require_dependency 'gopher'

class GopherTest < ActiveSupport::TestCase
  context "missing_pictures" do
    setup do
      ApodWeb.stubs(:index).returns(html_parser('index.html'))
    end

    test "with empty db" do
      assert_equal 809, Gopher.missing_pictures.size
    end

    test "missing_ident with 5 missing" do
      Picture.create(date: Date.new(2012, 9, 29))

      assert_equal 5, Gopher.missing_pictures.size
    end

    test "missing_ident without any missing" do
      Picture.create(date: Date.new(2012, 10, 4))

      assert_equal 0, Gopher.missing_pictures.size
    end
  end

  context "fetch_and_create_picture" do
    setup do
      ApodWeb.stubs(:view).returns(html_parser('view.html'))
    end

    def fetch # returns Picture obj here
      Gopher.fetch_and_create_picture({ id: 'ap123456', date: Date.new })
    end

    test "creates Picture record" do
      assert_difference('Picture.count') { fetch }
    end

    test "title" do
      picture = fetch

      assert_equal 'Introducing Comet ISON', picture.title
    end

    test "credit" do
      picture = fetch

      assert_match %r[</a>$], picture.credit
      assert_no_match %r[Introducing Comet ISON|Image Credit & Copyright:], picture.credit
    end

    test "explanation" do
      picture = fetch

      # there are 16 A elements in this explanation plus one empty that gets removed
      assert_equal 16, picture.explanation.scan(%r[</a>]).size
      #assert %Q|<img src="image/1210/ison_rolando_960.jpg">| picture.media
    end

    test "media" do
      picture = fetch

      assert_equal '<img src="image/1210/ison_rolando_960.jpg">', picture.media
    end

    test "media_link" do
      picture = fetch

      assert_equal 'image/1210/ison_rolando_1600.jpg', picture.media_link
    end

    context "with utf8 bytes" do
      setup do
        ApodWeb.stubs(:view).returns(html_parser('view_utf.html'))
      end

      test "encodes HTML entity" do
        # UTF8 characters are escaped properly (thx nokogiri)
        assert fetch.explanation.include?('&oslash')
      end
    end
  end
end
