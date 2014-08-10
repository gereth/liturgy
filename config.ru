$:.unshift(File.expand_path('../lib', __FILE__))

require 'rubygems'
require 'bundler'
Bundler.require(:default)

require 'dotenv'
Dotenv.load

require 'json'
require './app'
require 'realization'
require 'active_support/core_ext/hash/slice'
run App if defined?(run)
