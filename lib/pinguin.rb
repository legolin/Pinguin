require 'rubygems'
require 'bundler'
Bundler.require

ENV['RACK_ENV'] ||= 'development'

BASEDIR = File.join(File.dirname(__FILE__), '..')

Daemons.daemonize :dir_mode => :system if ARGV.include?('-d')

mongoid_config_file = File.join(BASEDIR, 'config', 'mongoid.yml')
Mongoid.load!(mongoid_config_file)

Dir.chdir(File.join(BASEDIR, 'lib'))

require 'pinguin/host'
require 'pinguin/request'
require 'pinguin/penguin'

config_file = File.join(BASEDIR, 'config', 'pinguin.yml')
monitor = Pinguin::Penguin.new(config_file)
  
# Run the monitor
monitor.run
