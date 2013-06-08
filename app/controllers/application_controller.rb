class ApplicationController < ActionController::Base
  protect_from_forgery

  def fetch_vnstats (device)
    vnstat = {}

    vnstat_dump = `vnstat -i #{device} --dumpdb`
    if vnstat_dump && vnstat_dump.lines.count > 2
      vnstat[:raw_days] = `vnstat -i #{device} -d`
      vnstat[:raw_months] = `vnstat -i #{device} -m`
      vnstat[:oneline] = `vnstat -i #{device} --oneline`

      # process @vnstat_dump into :days and :months
      vnstat[:days] = []
      vnstat[:months] = []
      vnstat_dump.lines.each do |r|
        f = r.split(';')
        case f[0]
        when 'm'
          vnstat[:months] << r if f[7].strip == "1"
        when 'd'
          vnstat[:days] << r if f[7].strip == "1"
        end
      end
    end

    return vnstat
  end

end
