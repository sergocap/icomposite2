class IcsController < ApplicationController
  before_action :find_ic
  def show
    @ics = Ic.all
  end

  def new
    @ic = Ic.new
  end

  def create
    @ic = Ic.create ic_params
    @ic.create_html
    redirect_to ic_path(@ic)
  end

  def find_ic
    @ic = params[:id] ? Ic.find(params[:id]) : Ic.last
  end

  def ic_params
    params.require(:ic).permit(:title, :place_height, :place_width, :image)
  end
end
