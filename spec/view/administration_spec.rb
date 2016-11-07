require 'rspec'
require 'rails_helper'

describe 'manage users', :type => :feature do

  it 'change user role to admin' do

    user = create(:user)

    admin = create(:other_user)
    admin.role = 'admin'
    admin.save

    visit new_user_session_path
    fill_in 'user[email]', with: admin.email
    fill_in 'user[password]', with: admin.password
    click_button I18n.t('auth.login.submit')

    visit users_path
    find_link('edit', href: user_path(user)).click
    expect(page).to have_field('Email', with: user.email, disabled: true)
    page.select 'admin', from: 'Role'
    click_button 'Save'

    expect(User.find_by_id(user.id).role).to eq 'admin'
  end
end