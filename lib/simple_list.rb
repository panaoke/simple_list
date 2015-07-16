require 'active_support'
require 'will_paginate'
require 'cancan'
module SimpleList
	extend ActiveSupport::Autoload

	autoload :Controller
	autoload :Helper
	autoload :Config

	def self.root
		File.expand_path('../..', __FILE__)
	end

end

require 'simple_list/engine'