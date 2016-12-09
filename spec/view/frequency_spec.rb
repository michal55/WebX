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

    visit project_script_path(project.id, script.id)
    expect(page).to have_link(href: edit_project_script_frequency_path(project.id,script.id, frequency.id))
  end

  #TODO: fix test
  # it 'should add frequency in tables' do
  #   script = create(:script)
  #   project = script.project
  #   user = script.project.user
  #   user.confirm
  #   expect(user.confirmed?).to eq true
  #   visit new_user_session_path
  #
  #   fill_in 'user[email]', with: user.email
  #   fill_in 'user[password]', with: user.password
  #   click_button 'Log in'
  #
  #   visit project_script_path(project.id,script.id)
  #   expect(page).to have_button(I18n.t('frequencies.new_button'))
  #
  #   fill_in 'frequency[interval]', with: "5"
  #   click_button I18n.t('frequencies.new_button')
  #   sleep(5)
  #   visit current_path
  #   puts page.body
  #
  #   expect(page).to have_content("5")
  # end

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
    expect(page).to have_link(I18n.t('buttons.back'))
    fill_in 'frequency[interval]', with: '235'
    click_button 'Save'
    expect(page).to have_content '235'
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

    visit project_script_path(project.id,script.id)
    page.click_link(href: project_script_frequency_path(project.id, script.id, frequency.id))
    expect(page).not_to have_link(href: project_script_frequency_path(project.id, script.id, frequency.id))
  end
end
