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


    visit project_data_fields_path(project.id)
    expect(page).to have_link(data_field.name, href: edit_project_data_field_path(project.id,data_field.id))

    visit edit_project_data_field_path(project.id,data_field.id)
    expect(page).to have_selector('input[value="' + data_field.name + '"]')
    expect(page).to have_content(data_field.data_type)
    expect(page).to have_link(I18n.t('buttons.delete'), href: project_data_field_path(project.id,data_field.id))
    expect(page).to have_button(I18n.t('buttons.submit'))
    expect(page).to have_link(I18n.t('buttons.back'), href: project_data_fields_path(project.id))

  end
end
