require 'rails_helper'

describe 'the login process', :type => :feature do
  it 'logs in valid user' do
    user = create(:user)
    user.confirm!
    expect(user.confirmed?).to eq true
    visit new_user_session_path

    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'Log in'

    # Expect logout button to be present
    # FIXME:
    # destroy_user_session_path == '/Webx/logout'
    # page.body contains "/logout"
    # Why it works with new_user_session_path?
    expect(page).to have_link('Logout', href: destroy_user_session_path)
  end

  it 'rejects user with invalid password' do
    user = create(:user)
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: 'invalid_' + user.password
    click_button 'Log in'

    # Expect log in button to be still present
    expect(page).to have_link('Log in', href: new_user_session_path)
  end

  it 'logs in valid admin' do
    admin = create(:user)
    admin.role = 'admin'
    admin.save!
    visit new_user_session_path
    fill_in 'user[email]', with: admin.email
    fill_in 'user[password]', with: admin.password
    click_button 'Log in'

    # Expect admin link to be present
    expect(page).to have_link('Administracia', href:  users_path )

  end

  it 'logs in unconfirmed user'do
      user = create(:user)
      expect(user.confirmed?).to eq false

      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'Log in'
      expect(page).to have_link('Logout', href:  destroy_user_session_path  )#, href: destroy_user_session_path)

  end
end
