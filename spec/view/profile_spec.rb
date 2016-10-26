require 'rspec'

describe 'check profile', :type => :feature do

  it 'check own profile' do
    user = create(:user)
    visit new_user_session_path

    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button I18n.t('auth.login.submit')

    visit profile_path(user)
    expect(page).to have_link(I18n.t('users.settings'))

  end

end