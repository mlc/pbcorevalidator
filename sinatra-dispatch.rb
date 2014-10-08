#!/usr/bin/ruby
# -*- coding: utf-8 -*-

# PBCore Validator, sinatra wrapper
# Copyright © 2009 Roasted Vermicelli, LLC
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

$: << File.expand_path(File.dirname(__FILE__))

require 'bundler'
require 'cgi'
Bundler.require

require 'lib/validator'

class App < Sinatra::Application

get '/' do
  haml :index
end

get '/validator' do
  "Sorry, only POST is supported."
end

post '/validator' do
  version = params[:version]
  unless (version && Validator::PBCORE_VERSIONS[version])
    halt "You must select a PBCore version to validate against." and return
  end

  if params[:file] && params[:file][:tempfile] && params[:file][:tempfile].size > 0
    @validator = Validator.new(params[:file][:tempfile], version)
  elsif !params[:textarea].strip.empty?
    @validator = Validator.new(params[:textarea], version)
  else
    halt "You must provide a PBCore document either by file upload or by pasting into the textarea."
  end

  haml :htmlout
end

get '/css' do
  content_type "text/css", :charset => "utf-8"
  response['Cache-Control'] = 'public, max-age=7200'
  sass :style
end

end
