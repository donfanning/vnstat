module Vnstats
  WARNING_USAGE_GB = (ENV["warning_usage_gb"].nil? ? 80 : ENV["warning_usage_gb"].to_i)
  CRITICAL_USAGE_GB = (ENV["critical_usage_gb"].nil? ? 95 : ENV["critical_usage_gb"].to_i)

  def fetch_vnstats (device)
    Rails.cache.fetch(device, :expires_in => 5.minutes) do 
      Rails.logger.debug("running vnstat #{device}")
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
            vnstat[:months] << f if f[7].strip == "1"
          when 'd'
            vnstat[:days] << f if f[7].strip == "1"
          when 'interface'
            vnstat[:device] = f[1].strip
          when 'nick'
            vnstat[:nick] = f[1].strip
            # see if we have application config to supercede this
            vnstat[:nick] = ENV[device] if ENV.has_key?(device)
          end
        end

        # determine the estimated monthly usage and its status class
        # vnstat[:estimated_monthly_usage] = vnstat[:raw_months].lines.last.split('|')[2]
        # estimated_monthly_usage = vnstat[:estimated_monthly_usage].to_f
        # estimated_monthly_usage /= (1024 * 1024) if vnstat[:estimated_monthly_usage].include? 'KiB'
        # estimated_monthly_usage /= 1024 if vnstat[:estimated_monthly_usage].include? 'MiB'

        # cycle usage
        # comment out old method above and use billing_cycle_day
        day_start = 1
        day_start = ENV["billing_cycle_start"].to_i unless ENV["billing_cycle_start"].blank?
        days_in_month = Date.today.end_of_month.day
        since = Date.new(Date.today.year, Date.today.month, day_start)
        if Date.today.day < since.day 
          # we are in the prior cycle
          since = since - 1.month
          days_in_month = since.end_of_month.day
        end
Rails.logger.debug("since = #{since}")
        vnstat[:cycle_start] = since
        cycle_usage = 0
        days = 0
        vnstat[:days].collect do |d|
          if Time.at(d[2].to_i) >= since
            days += 1
            cycle_usage += (d[3].to_i + d[4].to_i)
          end
        end
        cycle_usage /= 1024.0
        vnstat[:cycle_usage] = cycle_usage.to_s

        estimated_monthly_usage = (cycle_usage / days * days_in_month)
        vnstat[:estimated_monthly_usage] = estimated_monthly_usage.to_s
        case 
        when estimated_monthly_usage > CRITICAL_USAGE_GB
          vnstat[:estimated_monthly_status] = 'danger'
        when estimated_monthly_usage > WARNING_USAGE_GB
          vnstat[:estimated_monthly_status] = 'warn'
        else
          vnstat[:estimated_monthly_status] = 'success'
        end
      end
      vnstat
    end
  end

  def get_first_device
    begin
      f = `vnstat --oneline`.lines.first.split(';')[1]
    rescue
    end
    f
  end
end
