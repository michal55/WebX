# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment', __FILE__)
#run Rails.application
map WebX::Application.config.relative_url_root || "/" do
  map "/resque_web" do
    #use Rack::Auth::Basic do |username, password|
    #  [username, password] == [ACCESS_CONFIG['resque_username'], ACCESS_CONFIG['resque_password']]
    #end if ENV['RACK_ENV'].to_s.eql?('production')
    run Resque::Server.new
  end
  run Rails.application
end

