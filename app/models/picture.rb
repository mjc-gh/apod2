class Picture < ActiveRecord::Base
  attr_protected

  def self.last
    order('ident DESC').first
  end
end
