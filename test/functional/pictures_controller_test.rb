require 'test_helper'

class PicturesControllerTest < ActionController::TestCase
  test "show" do
    Picture.create(date: Date.new(2012, 9, 30))

    get :show, id: 'ap120930'

    assert_response :success
    assert_template :show
  end

  test "show from 90s" do
    Picture.create(date: Date.new(1996, 9, 30))

    get :show, id: 'ap960930'

    assert_response :success
    assert_template :show
  end
end
