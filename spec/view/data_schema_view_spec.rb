require 'rspec'
require 'rails_helper'


describe 'DataSchemaView', :type => :feature do

  it 'should display data schema' do

    data_field = create(:data_field)
    project = data_field.project
    user = data_field.project.user
    user.confirm
    expect(user.confirmed?).to eq true
    visit new_user_session_path

    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'Log in'


    visit project_path(project.id)
    expect(page).to have_link(data_field.name, href: edit_project_data_field_path(project.id,data_field.id))
  end
end
