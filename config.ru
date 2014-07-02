
require 'rubygems'
require 'bundler'
Bundler.require(:default)

require 'dotenv'
Dotenv.load

require './app'
run Api
