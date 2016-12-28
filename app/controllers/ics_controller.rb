class IcsController < ApplicationController
  inherit_resources
  authorize_resource
  actions :all, :except => [ :show  ]

  def show
    @ics = Ic.all
    @ic = params[:id] ? Ic.find(params[:id]) : Ic.last
  end

  def create
    create! do |format|
      format.html { @ic.create_html; redirect_to root_path }
    end
  end

  def permitted_params
    params.permit(:ic => [:title, :image, :place_height, :place_width])
  end
end
