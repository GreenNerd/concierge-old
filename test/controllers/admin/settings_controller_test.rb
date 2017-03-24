require 'test_helper'

class Admin::SettingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    FactoryGirl.create :setting
  end

  test 'should get show successfully' do
    get admin_settings_url
    assert_response :success
  end

  test 'should show settings' do
    get admin_settings_url
    assert_select 'title', '设置-在线排号系统'
  end

  test 'should show display the inst_no' do
    get admin_settings_url
    assert_select 'div', '网点编号'
  end

  test 'should update term_no' do
    new_term_no = '123123'

    patch admin_settings_url,
      params: { setting: { term_no: new_term_no } },
      xhr: true

    assert_equal new_term_no, Setting.instance.reload.term_no
  end
end
