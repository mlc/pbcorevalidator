require 'sinatra-dispatch'

set :views, File.dirname(__FILE__) + '/templates'

run Sinatra::Application
