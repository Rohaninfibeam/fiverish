class ServicesController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_service, only: [:show, :edit, :update]
  def index
    @services = current_user.services
  end

  def show
    @service = Service.find(params[:id])
  end

  def new
    @service = current_user.services.build
  end

  def create
    @service = current_user.services.new(service_params)
    if(!@service.save)
      render "new"
    else
      flash[:success] = "Successfully created..."
      redirect_to :action=>"show", :id=>@service.id
    end
  end

  def all_services
    @services = Service.all
  end

  def edit
  end

  def update
    @service.update_attributes!(service_params)
    if(!@service.save)
      render "edit"
    else
      flash[:success] = "Successfully updated..."
      redirect_to :action=>"show", :id=>@service.id
    end
  end

  private
  def set_service
    @service = Service.find(params[:id])
  end

  def service_params
    params.require(:service).permit(:id,:title,:description,:requirements,:price,:image)
  end
end
