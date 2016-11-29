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
    expect(page).to have_link(project.name, href: edit_project_path(project.id))
    expect(page).to have_link(I18n.t('projects.columns.action'),href: project_scripts_path(project.id))

    visit edit_project_path(project.id)
    expect(page).to have_link(I18n.t('buttons.delete'), href:project_path(project.id))
    expect(page).to have_button(I18n.t('buttons.submit'))
    expect(page).to have_link(I18n.t('buttons.back'), href: projects_path)

    visit project_scripts_path(project.id)
    expect(page).to have_link(script.name, href: project_script_path(project.id,script.id))

    visit edit_project_script_path(project.id,script.id)
    expect(page).to have_link(I18n.t('buttons.delete'), href: project_script_path(project.id,script.id))
    expect(page).to have_button(I18n.t('buttons.submit'))
    expect(page).to have_link(I18n.t('buttons.back'), href: project_scripts_path(project.id))
  end
end
