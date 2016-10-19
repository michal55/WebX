require 'rspec'
require 'rails_helper'

describe 'manage users', :type => :feature do

  it 'change user role to admin' do

    user = create(:user)

    visit  new_user_registration_path
    fill_in 'user[email]', with: 'xyz@xyz.xy'
    fill_in 'user[password]', with: '12345678'
    fill_in 'user[password_confirmation]', with: '12345678'
    click_button 'Sign up'

    admin = User.find_by(:email => 'xyz@xyz.xy')
    admin.role = 'admin'
    admin.save!

    visit users_path

    click_link user.email
    expect(page).to have_field('Email', with: user.email, disabled: true)

    page.select 'admin', from: 'Role'

    click_button 'Save'

    expect(User.find_by_id(user.id).role).to eq 'admin'
  end
end