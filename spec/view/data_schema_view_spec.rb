require 'rspec'
require 'rails_helper'


describe 'DataSchemaView', :type => :feature do

  it 'should display data schema' do

    data_schema = create(:data_schema)
    project = data_schema.project
    user = data_schema.project.user
    user.confirm
    expect(user.confirmed?).to eq true
    visit new_user_session_path

    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'Log in'


    visit project_data_schemas_path(project.id)
    expect(page).to have_link(data_schema.name, href: edit_project_data_schema_path(project.id,data_schema.id))

    visit edit_project_data_schema_path(project.id,data_schema.id)
    expect(page).to have_selector('input[value="' + data_schema.name + '"]')
    expect(page).to have_content(data_schema.data_type)
    expect(page).to have_link(I18n.t('buttons.delete'), href: project_data_schema_path(project.id,data_schema.id))
    expect(page).to have_button(I18n.t('buttons.submit'))
    expect(page).to have_link(I18n.t('buttons.back'), href: project_data_schemas_path(project.id))

  end
end
