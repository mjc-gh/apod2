require 'test_helper'
require_dependency 'gopher'

class GopherTest < ActiveSupport::TestCase
  context "apid_index" do
    setup do
      ApodWeb.stubs(:index).returns(html_parser('index.html'))
    end

    test "finds all" do
      assert_equal 809, Gopher.apid_index.size
    end

    test "includes id" do
      assert_includes Gopher.apid_index.first, :id
    end

    test "includes date" do
      assert_includes Gopher.apid_index.first, :date
    end

    context "missing_pictures" do
      test "with empty db" do
        assert_equal 809, Gopher.missing_pictures.size
      end

      test "with 5 missing" do
        Picture.create(date: Date.new(2012, 9, 29))

        assert_equal 5, Gopher.missing_pictures.size
      end

      test "without any missing" do
        Picture.create(date: Date.new(2012, 10, 4))

        assert_equal 0, Gopher.missing_pictures.size
      end

      test "order is correct" do
        Picture.create(date: Date.new(2012, 10, 1))
        missing = Gopher.missing_pictures

        assert_operator missing.size, :>, 0 # not empty

        (1..missing.size - 2).each do |index|
          assert_operator missing[index][:date], :<, missing[index+1][:date]
        end
      end
    end
  end

  context "fetch_and_create_picture" do
    setup do
      ApodWeb.stubs(:view).returns(html_parser('view.html'))
    end

    def fetch # returns Picture obj here
      Gopher.fetch_and_create_picture id: 'ap123456', date: Date.new
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

      assert_equal "<img src=\"#{ApodWeb::base_uri}/image/1210/ison_rolando_960.jpg\">", picture.media
    end

    test "media_link" do
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

    context "page with utf8" do
      test "encodes HTML entity" do
        ApodWeb.stubs(:view).returns(html_parser('view_utf.html'))

        assert_includes fetch.explanation, '&oslash'
      end
    end

    context "Picture date exists" do
      setup do
        Picture.create id: 'ap123456', date: Date.new
      end

      test "uses existing picture" do
        original = Picture.last
        picture = fetch

        assert_equal original.id, picture.id
      end

      test "does not create new Picture" do
        assert_no_difference('Picture.count') { fetch }
      end
    end
  end
end
