require 'test_helper'

class PictureTest < ActiveSupport::TestCase
  test "next_picture" do
    pictures = 3.times.map { |n| Picture.create(date: (Time.now - n.days).to_date) }

    assert_nil pictures[0].next_picture
    assert_equal pictures[0], pictures[1].next_picture
    assert_equal pictures[1], pictures[2].next_picture
  end

  test "previous picture" do
    pictures = 3.times.map { |n| Picture.create(date: (Time.now - n.days).to_date) }

    assert_nil pictures[2].previous_picture
    assert_equal pictures[2], pictures[1].previous_picture
    assert_equal pictures[1], pictures[0].previous_picture
  end

  test "to_param" do
    assert_equal 'ap950115', Picture.new(date: Date.new(1995, 1, 15)).to_param
    assert_equal 'ap051201', Picture.new(date: Date.new(2005, 12, 1)).to_param
  end

  test "self.date_from_apid" do
    assert_equal Date.new(1995, 1, 15), Picture.date_from_apid('ap950115')
    assert_equal Date.new(2005, 12, 1), Picture.date_from_apid('ap051201')

    assert_equal nil, Picture.date_from_apid('ap')
    assert_equal nil, Picture.date_from_apid('ap05')
    assert_equal nil, Picture.date_from_apid('ap0504')
    assert_equal nil, Picture.date_from_apid('ap053099')
  end
end
