namespace :db do
  desc 'Initialize elastic index'
  task :elastic_init => :environment do
    Log.create_index! force: true
  end
end