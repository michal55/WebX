def new_project(name, user_id)
  project = Project.new
  project.assign_attributes({name: name, user_id: user_id})
  project.save!
  project
end

def new_script(name, project_id)
  script = Script.new
  script.assign_attributes({name: name, project_id: project_id})
  script.save!
  script
end

def new_data_field(name, data_type, project_id)
  data_field = DataField.new
  data_field.assign_attributes({name: name, data_type: data_type.to_i, project_id: project_id})
  data_field.save!
  data_field
end

namespace :db do
  desc 'Seed database with some default data for manual testing'
  task :seed_dev => :environment do
    user1 = User.create! :email => 'a@a.a', :password => '123456789', :password_confirmation => '123456789'
    user1.confirm
    user2 = User.create! :email => 'b@b.b', :password => '123456789', :password_confirmation => '123456789'
    user2.confirm

    project1 = new_project('project 1', user1.id)
    project2 = new_project('project 2', user1.id)
    project3 = new_project('project 3', user2.id)

    script1 = new_script('script 1', project1.id)
    script2 = new_script('script 2', project1.id)
    script3 = new_script('script 3', project2.id)
    script4 = new_script('script 4', project3.id)
    script5 = new_script('script 5', project3.id)

    data_field1 = new_data_field('data field 1', DataField.data_types[:integer], project1.id)
    data_field2 = new_data_field('data field 2', DataField.data_types[:string], project1.id)
    data_field3 = new_data_field('data field 3', DataField.data_types[:integer], project2.id)
    data_field4 = new_data_field('data field 4', DataField.data_types[:integer], project3.id)
  end
end
