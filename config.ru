# This file is used by Rack-based servers to start the application.

#require 'rack/bug'

require ::File.expand_path('../config/environment',  __FILE__)
#Flixrmi::Application.middleware.use Oink::Middleware

#use Rack::Bug, :secret_key => "someverylongandveryhardtoguesspreferablyrandomstring"
   
run Flixrmi::Application
