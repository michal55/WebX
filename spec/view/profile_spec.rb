require 'rspec'

describe 'check profile', :type => :feature do

  it 'check own profile' do
    user = create(:user)
    visit new_user_session_path

    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button I18n.t('auth.login.submit')

    visit profile_path(user)
    expect(page).to have_content(user.email)

  end

  it 'change user name' do
    user = create(:user)
    visit new_user_session_path

    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button I18n.t('auth.login.submit')

    visit edit_user_registration_path(user)
    fill_in 'name', with: 'new_name'
    fill_in 'user_current_password', with: user.password
    # puts page.body
    click_button 'Update'

    visit profile_path(user)
    expect(page).to have_content 'new_name'
  end

end