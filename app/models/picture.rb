class Picture < ActiveRecord::Base
  attr_protected

  scope :latest, order('date DESC')

  def self.last
    latest.first
  end
end
