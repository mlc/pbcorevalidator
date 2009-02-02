#!/usr/bin/ruby

# PBCore Validator, FastCGI wrapper
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
require 'libxml'

require 'lib/validator'

cgi = CGI.new

def fail(cgi, message)
  cgi.out("type" => "text/plain", "charset" => "utf-8", "status" => "OK") do
    message
  end
  exit 0
end

@validator = if cgi.params["file"].respond_to?(:content_type)
  Validator.new(cgi.params["file"])
elsif !(cgi.params["textarea"].empty?)
  Validator.new(cgi.params["textarea"][0])
else
  fail(cgi, "You must provide a PBCore document either by file upload or by pasting into the textarea.")
end

engine = Haml::Engine.new(File.read(File.join(File.dirname(__FILE__), "lib", "htmlout.haml")))
cgi.out("type" => "text/html", "charset" => "utf-8") do
  engine.to_html(Object.new, { :validator => @validator })
end