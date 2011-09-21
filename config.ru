require 'rubygems'
require 'bundler'

Bundler.require

mongoid_config_file = File.join('config', 'mongoid.yml')
Mongoid.load!(mongoid_config_file)

require 'app/stats'
run Sinatra::Application