# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

desc 'API Routes'
task :routes do
  API::Root.routes.each do |api|
    method = api.request_method.ljust(10)
    path = api.path
    puts "     #{method} #{path}"
  end
end
