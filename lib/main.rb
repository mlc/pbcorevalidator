# PBCore Validator, main file
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

$: << File.expand_path(File.dirname(__FILE__) + "/../lib")

require 'rubygems'
require 'lib/validator'

val = nil
File.open(ARGV[0], "r") do |f|
  val = Validator.new(f)
end

val.checkschema

if val.valid?
  puts "valid record!"
end

val.errors.each do |e|
  $stderr.puts e
end
