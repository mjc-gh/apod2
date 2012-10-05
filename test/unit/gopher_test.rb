require 'test_helper'
require_dependency 'gopher'

class GopherTest < ActiveSupport::TestCase
  setup do
    ApodWeb.stubs(:index).returns(html_parser('index.html'))
  end

  test "missing_ident with empty db" do
    assert_equal 778, Gopher.missing_idents.size
  end

  test "missing_ident with 3 missing" do
    Picture.create(ident: 'ap121001')

    assert_equal 3, Gopher.missing_idents.size
  end

  test "missing_ident without any missing" do
    Picture.create(ident: 'ap121004')

    assert_equal 0, Gopher.missing_idents.size
  end
end
