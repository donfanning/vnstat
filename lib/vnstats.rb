module Vnstats
  WARNING_USAGE_GB = (ENV["WARNING_USAGE_GB"].nil? ? 80 : ENV["WARNING_USAGE_GB"].to_i)
  CRITICAL_USAGE_GB = (ENV["CRITICAL_USAGE_GB"].nil? ? 95 : ENV["CRITICAL_USAGE_GB"].to_i)

  def fetch_vnstats (device)
    Rails.cache.fetch(device, :expires_in => 5.minutes) do 
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
          when 'interface'
            vnstat[:device] = f[1].strip
          when 'nick'
            vnstat[:nick] = f[1].strip
            # see if we have application config to supercede this
            vnstat[:nick] = ENV[device] if ENV.has_key?(device)
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
