require 'test_helper'

class SettingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    FactoryGirl.create :setting
    @admin_headers = { 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials('admin', 'secret') }
  end

  test 'should get show successfully' do
    get settings_url, headers: @admin_headers
    assert_response :success
  end

  test 'should show settings' do
    get settings_url, headers: @admin_headers
    assert_select 'title', '设置-在线排号系统'
  end

  test 'should show display the inst_no' do
    get settings_url, headers: @admin_headers
    assert_select 'div', '网点编号'
  end

  test 'should update term_no' do
    new_term_no = '123123'

    patch settings_url,
      params: { setting: { term_no: new_term_no } },
      headers: @admin_headers,
      xhr: true

    assert_equal new_term_no, Setting.instance.reload.term_no
  end
end
