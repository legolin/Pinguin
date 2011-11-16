require 'rubygems'
require 'bundler'
Bundler.require
require 'cassandra'

env = ENV['RACK_ENV'] ||= 'development'

BASEDIR = File.join(File.dirname(__FILE__), '..')

Daemons.daemonize :dir_mode => :system if ARGV.include?('-d')

Dir.chdir(File.join(BASEDIR, 'lib'))

require 'pinguin/penguin'
require 'pinguin/cassandra'
require 'pinguin/host'
require 'pinguin/request'


# Hook up to cassandra
cassandra_config_file = File.join(BASEDIR, 'config', 'cassandra.yml')
cassandra_config = YAML::load_file(cassandra_config_file)[env]
puts cassandra_config.inspect
client = Cassandra.new(cassandra_config['keyspace'], "#{cassandra_config['host']}:9160")
client.login!(cassandra_config['username'], cassandra_config['password']) if cassandra_config['username']

# Create the monitor
config_file = File.join(BASEDIR, 'config', 'pinguin.yml')
monitor = Pinguin::Penguin.new(config_file, client)
  

# Run the monitor
monitor.run
