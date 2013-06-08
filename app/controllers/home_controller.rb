class HomeController < ApplicationController
  DEVICE = "eth0"
  
  def index
    vnstat_dump = `vnstat -i #{DEVICE} --dumpdb`
    vnstat_dump = nil
    if vnstat_dump
      if vnstat_dump.lines.count <= 2
        flash[:error] = vnstat_dump
      else
        @vnstat_days = `vnstat -i #{DEVICE} -d`
        @vnstat_months = `vnstat -i #{DEVICE} -m`
        @vnstat_oneline = `vnstat -i #{DEVICE} --oneline`

        # process @vnstat_dump into :days and :months
        @vnstat[:days] = []
        @vnstat[:months] = []

        vnstat_dump.each do |r|
          f = r.split(';')
          case f[0]
          when 'm'
            @vnstat[:months] << r if f[8] == 1
          when 'd'
            @vnstat[:days] << r if f[8] == 1
          end
        end
      end
    else 
      flash[:error] = "Unable to get results from vnstat, is it installed?"
    end
  end
end
