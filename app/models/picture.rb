class Picture < ActiveRecord::Base
  attr_protected

  def self.last
    order('date DESC').first
  end
end
