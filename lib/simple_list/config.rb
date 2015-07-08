require 'yaml'
module SimpleList
	class Config
		include Singleton
		attr_reader :config, :path

		def self.init(path = "#{Rails.root}/config/simple_list.yml")
			self.instance.send(:set_path, path)
			self.load
			if self.config[:default] && (self.config[:default][:format_time] == true)
				require "#{SimpleList.root}/lib/simple_list/core/time"
			end
		end

		def load
			@config = HashWithIndifferentAccess.new(YAML.load_file(@path))
		end

		class << self
			[:load, :config].each do |name|
				define_method name do
					self.instance.send(name)
				end
			end
		end

		private
		def set_path(path)
			@path = path
		end

	end
end
