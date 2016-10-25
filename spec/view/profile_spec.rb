require 'rspec'

describe 'check profile', :type => :feature do

  it 'check own profile' do
    user = create(:user)
    visit new_user_session_path

    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'Log in'

    visit profile_path(user)
    expect(page).to have_link('Settings')

  end

  it 'check other profile' do
    user = create(:user)
    admin = create(:other_user)
    admin.role = 'admin'
    admin.save

    visit new_user_session_path
    fill_in 'user[email]', with: admin.email
    fill_in 'user[password]', with: admin.password
    click_button 'Log in'

    visit profile_path(user)
    expect(page).to_not have_link('Settings')

  end
end