class PicturesController < ApplicationController
  respond_to :html, :json, :xml

  def index
    @pictures = Picture.latest.limit(20)

    respond_with @pictures
  end

  def show
    # TODO update this when NASA figures out a new date scheme in for 2095+
    parts = params[:id].scan(%r[\d{2}]).map(&:to_i)
    parts[0] = parts[0] + (parts[0] >= 95 ? 1900 : 2000)

    @picture = Picture.where(date: Date.new(*parts)).first!

    respond_with @picture
  end

  def latest
    @picture = Picture.last

    respond_with @picture
  end
end
