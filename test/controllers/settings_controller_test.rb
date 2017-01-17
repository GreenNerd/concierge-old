require 'test_helper'

class SettingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @setting = FactoryGirl.create(:setting)
  end

  test 'should get show successfully' do
    get settings_url
    assert_response :success
  end

  test 'should show settings' do
    get settings_url
    assert_select 'title', '设置-在线排号系统'
  end

  test 'should show display the trans_code' do
    get settings_url
    assert_select 'div', '交易号'
  end
end
