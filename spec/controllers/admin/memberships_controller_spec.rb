require 'spec_helper'

describe Admin::DashboardController do
  include Devise::TestHelpers

  def mock_user(stubs={})
    @mock_user ||= mock_model(User, stubs).as_null_object
  end

  before do
    # this is required so we don't get redirected to the
    # 'create a first user' page
    Factory(:refinery_user)

    user = mock_user(:is_admin => true,
                     :authorized_plugins => [])

    # mock up an authentication in the underlying warden library
    request.env['warden'] = mock(Warden,:authenticate => user,
                                        :authenticate! => user,
                                        :authenticate? => true)
  end

  it 'should pass smoke test' do
    get :index
    response.should be_success
  end
end
