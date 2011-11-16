require 'rubygems'
require 'bundler'

Bundler.require

BASE_DIR = File.dirname(__FILE__)

require 'app/stats'
run Sinatra::Application