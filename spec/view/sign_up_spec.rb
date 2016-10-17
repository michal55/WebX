require 'rspec'
require 'rails_helper'

describe 'Register', :type => :feature do

  it 'should register new user'do
    visit 'join'
    fill_in 'user[email]', with: 'xyz@xyz.xy'
    fill_in 'user[password]', with: '12345678'
    fill_in 'user[password_confirmation]', with: '12345678'
    click_button 'Sign up'

    # user exists
    expect(User.exists?(email: 'xyz@xyz.xy')).to eq true

    # is logged in
    expect(page).to have_link('Logout', href: '/logout')
  end

  it 'should not register new user if password not matches'do
    visit 'join'
    fill_in 'user[email]', with: 'xyz@xyz.xy'
    fill_in 'user[password]', with: '12345678'
    fill_in 'user[password_confirmation]', with: '87654321'
    click_button 'Sign up'

    # user exists
    expect(User.exists?(email: 'xyz@xyz.xy')).to eq false

    # is logged in
    expect(page).not_to have_link('Logout', href: '/logout')
  end

  it 'should not register new user if password less than 8 char'do
    visit 'join'
    fill_in 'user[email]', with: 'xyz@xyz.xy'
    fill_in 'user[password]', with: 'abc'
    fill_in 'user[password_confirmation]', with: 'abc'
    click_button 'Sign up'

    # user exists
    expect(User.exists?(email: 'xyz@xyz.xy')).to eq false

    # is logged in
    expect(page).not_to have_link('Logout', href: '/logout')
  end
end