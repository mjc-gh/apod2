class Picture < ActiveRecord::Base
  attr_protected

  validates :date, presence: true

  scope :latest, order('date DESC')

  def next_picture
    self.class.where('date > ?', date).order('date ASC').first
  end

  def previous_picture
    self.class.where('date < ?', date).order('date DESC').first
  end

  def self.last
    latest.first
  end

  def to_param
    date.strftime 'ap%y%m%d'
  end
end
