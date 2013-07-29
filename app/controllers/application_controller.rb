class ApplicationController < ActionController::Base
  protect_from_forgery

  WARNING_USAGE_GB = 80
  CRITICAL_USAGE_GB = 95

  def fetch_vnstats (device)
    Rails.cache.fetch(device, :expires_in => 2.minutes) do 
      Rails.logger.debug('running vnstat')
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

        # determine the estimated monthly usage and its status class
        vnstat[:estimated_monthly_usage] = vnstat[:raw_months].lines.last.split('|')[2]
        estimated_monthly_usage = vnstat[:estimated_monthly_usage].to_f
        estimated_monthly_usage /= (1024 * 1024) if vnstat[:estimated_monthly_usage].include? 'KiB'
        estimated_monthly_usage /= 1024 if vnstat[:estimated_monthly_usage].include? 'MiB'
        case 
        when estimated_monthly_usage > CRITICAL_USAGE_GB
          vnstat[:estimated_monthly_status] = 'error'
        when estimated_monthly_usage > WARNING_USAGE_GB
          vnstat[:estimated_monthly_status] = 'warn'
        else
          vnstat[:estimated_monthly_status] = 'success'
        end
      end
      vnstat
    end
  end

end
