class Time
	def as_json(options = nil) #:nodoc:
		%(#{strftime("%Y/%m/%d %H:%M:%S")})
	end
end

class ActiveSupport::TimeWithZone
	def as_json(options = nil) #:nodoc:
		%(#{strftime("%Y/%m/%d %H:%M:%S")})
	end
end