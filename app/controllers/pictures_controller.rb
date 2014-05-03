class PicturesController < ApplicationController
  respond_to :html, :json

  def index
    @pictures = Picture.latest.with_media.limit(limit_param)
    @pictures = @pictures.before_apid(last_param) unless last_param.nil?

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

  def picture_params
    @picture_params ||= params.permit(:last, :limit)
  end

  def last_param
    picture_params[:last]
  end

  def limit_param
    limit = picture_params[:limit].to_i
    limit = 8 if limit < 1 || limit > 25
    limit
  end
end
