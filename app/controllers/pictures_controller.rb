class PicturesController < ApplicationController
  respond_to :html, :json, :xml

  def index
    @pictures = Picture.latest.limit(20)

    if params[:last]
      if date = Picture.date_from_apid(params[:last])
        @pictures = @pictures.where('date < ?', date)
      end
    end

    respond_with @pictures
  end

  def show
    date = Picture.date_from_apid(params[:id])
    @picture = Picture.where(date: date).first!

    respond_with @picture
  end

  def latest
    @picture = Picture.last

    respond_with @picture
  end
end
