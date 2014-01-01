class HomeController < ApplicationController
  def index
  	@device = params[:dev]
    if @device.nil?
      @device = get_first_device
    end
  	@device ||= "eth0"
    @vnstats = fetch_vnstats(@device)
    if @vnstats.empty?
      flash[:error] = "Unable to get results from vnstat, is it installed?"
    end
  end
end
