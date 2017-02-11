require 'test_helper'

class SyncHandlerTest < ActiveSupport::TestCase
  setup do
    FactoryGirl.create :setting

    total_xml_rsp = <<-EOF
      <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
      <Package>
      <RspCode>0</RspCode>
      <RspMsg>处理成功</RspMsg>
      <Servesingletype>0</Servesingletype>
      <Qcount>17</Qcount>
      <MarkScore>0</MarkScore>
      </Package>
    EOF

    pass_xml_rsp = <<-EOF
      <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
      <Package>
      <RspCode>0</RspCode>
      <RspMsg>处理成功</RspMsg>
      <Servesingletype>0</Servesingletype>
      <Qcount>4</Qcount>
      <MarkScore>0</MarkScore>
      </Package>
    EOF

    stub_request(:post, "#{Setting.instance.mip}/QueueServer/1.0/Services/numbercount")
      .to_return(body: total_xml_rsp)
    stub_request(:post, "#{Setting.instance.mip}/QueueServer/1.0/Services/passcount")
      .to_return(body: pass_xml_rsp)
  end

  test 'should store total number count' do
    run_job SyncHandler
    assert Setting.total_number_count, 17
  end

  test 'should store pass number count' do
    run_job SyncHandler
    assert Setting.pass_number_count, 4
  end
end
