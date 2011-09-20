# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
 
require 'bundler/version'
 
Gem::Specification.new do |s|
  s.name        = "pinguin"
  s.version     = Bundler::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Adam Elhardt"]
  s.email       = ["adam@sapphireim.com"]
  s.homepage    = "http://github.com/legolin/pinguin"
  s.summary     = "Simple website uptime monitor"
  s.description = "Pinguin periodically pings websites to calculate weekly uptime stats."
 
  s.required_rubygems_version = ">= 1.3.6"
 
  s.files        = Dir.glob("{bin,lib}/**/*") + %w(LICENSE README.md ROADMAP.md CHANGELOG.md)
  s.executables  = ['pinguin']
  s.require_path = 'lib'
end