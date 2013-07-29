
require "vnstats"
include Vnstats

# get tracked vnstat devices

AVAILABLE_DEVICES = {}

`ls /var/lib/vnstat`.split.each do |d|
	if d.start_with?("eth")
		vnstat = fetch_vnstats(d)
		if !vnstat.nil? and vnstat.has_key?(:device) and vnstat.has_key?(:nick)
			AVAILABLE_DEVICES[ vnstat[:device].to_sym ] = vnstat[:nick]
		end
	end
end

# `vnstat --dumpdb`.lines.each do |s|
# 	if s.start_with? "interface;"
# 		_if = s.split(";")[1].strip
# 	end
# 	if s.start_with? "nick;"
# 		_alias = s.split(";")[1].strip
# 		AVAILABLE_DEVICES[ _if.to_sym ] = _alias 
# 	end
# end

