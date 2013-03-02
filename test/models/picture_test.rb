require 'test_helper'

class PictureTest < ActiveSupport::TestCase
  test "next_picture" do
    pictures = 3.times.map { |n| Picture.create(date: (Time.now - n.days).to_date) }

    assert_equal [nil, pictures[0], pictures[1]], pictures.map(&:next_picture)
  end

  test "previous picture" do
    pictures = 3.times.map { |n| Picture.create(date: (Time.now - n.days).to_date) }

    assert_equal [pictures[1], pictures[2], nil], pictures.map(&:previous_picture)
  end

  test "to_param for the 90s" do
    assert_equal 'ap950115', Picture.new(date: Date.new(1995, 1, 15)).to_param
  end

  test "to_param for the 2000s" do
    assert_equal 'ap051201', Picture.new(date: Date.new(2005, 12, 1)).to_param
  end

  test "self.date_from_apid for the 90s" do
    assert_equal Date.new(1995, 1, 15), Picture.date_from_apid('ap950115')
  end

  test "self.date_from_apid for the 2000s" do
    assert_equal Date.new(2005, 12, 1), Picture.date_from_apid('ap051201')
  end

  test "self.date_from_apid for invalid ids" do
    dates = []

    dates << Picture.date_from_apid('ap')
    dates << Picture.date_from_apid('ap05')
    dates << Picture.date_from_apid('ap0504')
    dates << Picture.date_from_apid('ap053099')

    assert_empty dates.compact
  end
end
