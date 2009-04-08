#!/usr/bin/ruby

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

require 'rubygems'

require 'cgi'
require 'haml'
require 'sinatra'

require 'lib/validator'

set :host, 'localhost'

set :public, File.dirname(__FILE__) + '/html'
set :views, File.dirname(__FILE__) + '/templates'

get '/validator' do
  "Sorry, only POST is supported."
end

post '/validator' do
  if params[:file][:tempfile] && params[:file][:tempfile].size > 0
    @validator = Validator.new(params[:file][:tempfile])
  elsif !params[:textarea].strip.empty?
    @validator = Validator.new(params[:textarea])
  else
    halt "You must provide a PBCore document either by file upload or by pasting into the textarea."
  end

  haml :htmlout
end
