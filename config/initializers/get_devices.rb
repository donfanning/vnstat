
require "vnstats"
include Vnstats

# get tracked vnstat devices

AVAILABLE_DEVICES = {}

`ls /var/lib/vnstat`.split.each do |d|
	if d.start_with?("eth")
		vnstat = fetch_vnstats(d.strip)
		if !vnstat.nil? and vnstat.has_key?(:device) and vnstat.has_key?(:nick)
			AVAILABLE_DEVICES[ vnstat[:device].to_sym ] = vnstat[:nick]
		end
	end
end
