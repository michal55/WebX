require 'rspec'
require 'rails_helper'

describe 'see scripts', :type => :feature do

  it "should display script in tables" do
    script = create(:script)
    project = script.project
    user = script.project.user
    user.confirm
    expect(user.confirmed?).to eq true
    visit new_user_session_path

    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'Log in'

    visit projects_path
    expect(page).to have_link(project.name, href: project_path(project.id))

    visit project_path(project.id)
    expect(page).to have_link(script.name, href: project_script_path(project.id,script.id))
  end
end
