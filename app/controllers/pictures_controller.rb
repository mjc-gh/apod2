class PicturesController < ApplicationController
  respond_to :html, :json

  def index
    @pictures = Picture.latest.limit(60)
    @pictures = @pictures.before_apid(params[:last]) if params[:last]

    respond_with @pictures
  end

  def show
    @picture = Picture.by_apid(params[:id]).first!

    respond_with @picture
  end

  def latest
    @picture = Picture.latest.first!

    respond_with @picture, template: 'pictures/show'
  end
end
