# get tracked vnstat devices

AVAILABLE_DEVICES = {}

_if = ""
_alias = ""
`vnstat --dumpdb`.lines.each do |s|
	if s.start_with? "interface;"
		_if = s.split(";")[1].strip
	end
	if s.start_with? "nick;"
		_alias = s.split(";")[1].strip
		AVAILABLE_DEVICES[ _if.to_sym ] = _alias 
	end
end

