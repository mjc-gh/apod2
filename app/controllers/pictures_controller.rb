class PicturesController < ApplicationController
  respond_to :html, :json

  def index
    @pictures = Picture.latest.with_media.limit(limit_param)
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

  protected

  def limit_param
    @limit_param ||= valid_limit_param
  end

  def valid_limit_param
    limit = params[:limit].to_i
    limit = 8 if limit < 1 || limit > 25
    limit
  end
end
