require 'rspec'
require 'rails_helper'

describe 'CRUD frequencies', :type => :feature do

  it 'should display frequencies in tables' do
    frequency = create(:frequency)
    script = frequency.script
    project = script.project
    user = script.project.user
    user.confirm
    expect(user.confirmed?).to eq true
    visit new_user_session_path

    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'Log in'

    visit project_script_frequencies_path(project.id, script.id)
    expect(page).to have_link(I18n.t('frequencies.edit'), href: edit_project_script_frequency_path(project.id,script.id, frequency.id))
    expect(page).to have_link(I18n.t('frequencies.new_button'), href: new_project_script_frequency_path(project.id,script.id))
  end

  it 'should add frequency in tables' do
    script = create(:script)
    project = script.project
    user = script.project.user
    user.confirm
    expect(user.confirmed?).to eq true
    visit new_user_session_path

    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'Log in'

    visit new_project_script_frequency_path(project.id,script.id)
    expect(page).to have_button(I18n.t('buttons.create'))

    fill_in 'frequency[interval]', with: '50'
    click_button 'Create'
  end

  it 'should modify frequency in tables' do
    frequency = create(:frequency)
    script = frequency.script
    project = script.project
    user = script.project.user
    user.confirm
    expect(user.confirmed?).to eq true
    visit new_user_session_path

    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'Log in'

    visit edit_project_script_frequency_path(project.id, script.id, frequency.id)
    expect(page).to have_link(I18n.t('buttons.delete'), href: project_script_frequency_path(project.id, script.id, frequency.id))
    expect(page).to have_button(I18n.t('buttons.submit'))
    expect(page).to have_link(I18n.t('buttons.back'), href: project_script_frequencies_path(project.id, script.id))

    fill_in 'frequency[interval]', with: '235'
    click_button 'Save'
  end

  it 'should delete frequency in tables' do
    frequency = create(:frequency)
    script = frequency.script
    project = script.project
    user = script.project.user
    user.confirm
    expect(user.confirmed?).to eq true
    visit new_user_session_path

    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'Log in'

    visit edit_project_script_frequency_path(project.id, script.id, frequency.id)
    click_link 'Delete'
  end
end
