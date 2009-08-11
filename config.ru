require File.join(File.dirname(__FILE__), 'uph.rb')

disable :run
set :env, :production
run Sinatra.application