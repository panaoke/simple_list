$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'simple_list/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'simple_list'
  s.version     = SimpleList::VERSION
  s.authors     = ['panaoke']
  s.email       = ['panaoke@gmail.com']
  s.homepage    = 'https://github.com/panaoke/simple_list'
  s.summary     = 'Support standardization CRUD and list for model'
  s.description = 'Support standardization CRUD and list for model'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'rails', '>= 4.0.0'

  s.add_dependency 'will_paginate'

	s.add_dependency 'cancan'


end
