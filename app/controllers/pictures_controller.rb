class PicturesController < ApplicationController
  respond_to :html, :json, :xml

  def index
    @pictures = Picture.latest.limit(20)

    respond_with @pictures
  end

  def show
    @picture = Picture.find(params[:id])

    respond_with @picture
  end
end
