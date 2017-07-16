class PagesController < ApplicationController
  def home
    @services = Service.get_recent
  end
end
