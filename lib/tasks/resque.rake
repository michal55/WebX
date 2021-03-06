require 'resque/pool/tasks'

require 'resque/tasks'
task 'resque:setup' => :environment

task "resque:pool:setup" do
  ActiveRecord::Base.connection.disconnect!
  Resque::Pool.after_prefork do |job|
    ActiveRecord::Base.establish_connection
  end
end

