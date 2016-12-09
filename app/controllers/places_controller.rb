class PlacesController < ApplicationController
  inherit_resources
  before_filter :find_ic

  def new
    new! {
      @place.x = params[:x]
      @place.y = params[:y]
      @original_place = @ic.original_places.find_or_create_by(x: @place.x, y: @place.y, ic_id: @ic.id)
      render partial: 'places/new' and return
    }
  end

  def create
    create! do |format|
      format.html {
        @place.update_attribute(:ic_id, @ic.id)
        @place.process_image
        @ic.add_to_project(@place)
        redirect_to ic_path(@ic.id)
      }
    end
  end

  def show
    show! { render partial: 'places/show' and return }
  end

  def find_ic
    @ic = Ic.find(params[:ic_id])
  end

  def permitted_params
    params.permit(:place => [:x, :y, :image, :link, :comment,
                             :crop_x, :crop_y, :crop_width, :crop_height,
                             :saturate, :r_component, :g_component, :b_component,
                             :pre_height, :pre_width])
  end
end
