require 'test_helper'

class SettingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_headers = { 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials('admin', 'secret') }
    @setting = FactoryGirl.create(:setting)
  end

  test 'should get show successfully' do
    get settings_url, headers: @admin_headers
    assert_response :success
  end

  test 'should show settings' do
    get settings_url, headers: @admin_headers
    assert_select 'title', '设置-在线排号系统'
  end

  test 'should show display the trans_code' do
    get settings_url, headers: @admin_headers
    assert_select 'div', '交易号'
  end

  test 'should update trans_code' do
    new_trans_code = '123123'

    patch settings_url,
      params: { setting: { trans_code: new_trans_code } },
      headers: @admin_headers,
      xhr: true
    @setting.reload

    assert_equal new_trans_code, @setting.trans_code
  end
end
