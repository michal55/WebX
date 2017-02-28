require 'rspec'
require 'rails_helper'
describe 'Logging into elastic' do

  it 'Logs factory user', :elasticsearch do
    user = create(:user)
    Logging::Logger.debug(user.name, user)
    response = Log.search(
        {
            query: {
                bool: {
                    must: {
                        match: { msg: user.name }
                    }
                }
            }
        }
    ).response

    expect(response['hits']['hits'][0]['_source']['msg']).to eq(user.name)
  end
end