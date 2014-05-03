require 'test_helper'

class PicturesControllerTest < ActionController::TestCase
  test "show" do
    Picture.create(date: Date.new(2012, 9, 30))

    get :show, id: 'ap120930'

    assert_response :success
    assert_template :show
  end

  test "show not found" do
    get :show, id: 'ap112233'

    assert_redirected_to root_url
  end

  test "index" do
    (1..30).each { |n| Picture.create(date: Date.new(2012, 9, n)) }

    get :index

    assert_response :success
    assert_template :index
  end

  test "index with last" do
    (1..30).each { |n| Picture.create(date: Date.new(2012, 9, n), media_link: 'http://nasa.gov/img.png') }

    get :index, last: 'ap120915', limit: 25

    assert_equal 14, assigns(:pictures).size
  end

  test "latest" do
    Picture.create(date: Date.new(2012, 9, 30))

    get :latest

    assert_response :success
    assert_template :show
  end

  test "latest not found" do
    get :latest

    assert_redirected_to root_url
  end
end
