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

  test 'should update trans_code' do
    new_trans_code = '123123'

    patch settings_url, params: { setting: { trans_code: new_trans_code } }
    @setting.reload

    assert_equal new_trans_code, @setting.trans_code
    assert_equal '更新成功', flash[:success]
    assert_redirected_to settings_path
  end
end
