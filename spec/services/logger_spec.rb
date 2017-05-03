require 'rspec'
require 'rails_helper'

describe 'Logging into elastic' do

  it 'Logs factory user'   do
    user = create(:user)
    logger = Logging::Logger.new(severity: 'debug')
    logger.debug(user.name, user)
    Log.refresh_index!
    response = Log.search(
          query: {
                match: {
                    resource_type: "user" }
              }
    )
    expect(response[0]['msg']).to eq(user.name)
  end

  it 'Logs error but not debug' do
    user = create(:user)
    logger = Logging::Logger.new(severity: 'error')
    logger.debug("debug", user)
    logger.error("error", user)
    Log.refresh_index!
    debug_response = Log.search(
        query: {
            match: {
                msg: "debug"
            }
        }
    )
    expect(debug_response[0]).to eq(nil)

    error_response = Log.search(
        query: {
            match: {
                msg: "error"
            }
        }
    )
    expect(error_response[0]['msg']).to eq("error")

  end
end



