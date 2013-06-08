class HomeController < ApplicationController
  def index
    @vnstats = fetch_vnstats('eth0')
    if @vnstats.empty?
      flash[:error] = "Unable to get results from vnstat, is it installed?"
    end
  end
end
