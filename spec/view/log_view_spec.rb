require 'rspec'
require 'rails_helper'

describe 'Displaying logs ', :type => :feature do
  it 'show logs' do
    extraction = create(:extraction)
    user = extraction.script.project.user

    logger = Logging::Logger.new(severity: 'debug')
    logger.debug("debug_text", extraction)
    logger.error("error_text", extraction)

    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button I18n.t('auth.login.submit')

    Log.refresh_index!

    visit project_script_extraction_logs_path(extraction.script.project_id,extraction.script_id, extraction.id)
    expect(page).to have_text("debug_text")
    expect(page).to have_text("error_text")
  end
end
