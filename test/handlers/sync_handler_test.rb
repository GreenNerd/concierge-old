class SyncHandlerTest < ActiveSupport::TestCase
  setup do
    @scheduler = Rufus::Scheduler.new
    Setting.instance.update_columns limitation: 1000

    total_xml_res = <<-EOF
      <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
      <Package>
      <RspCode>0</RspCode>
      <RspMsg>处理成功</RspMsg>
      <Servesingletype>0</Servesingletype>
      <Qcount>17</Qcount>
      <MarkScore>0</MarkScore>
      </Package>
    EOF

    pass_xml_res = <<-EOF
      <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
      <Package>
      <RspCode>0</RspCode>
      <RspMsg>处理成功</RspMsg>
      <Servesingletype>0</Servesingletype>
      <Qcount>4</Qcount>
      <MarkScore>0</MarkScore>
      </Package>
    EOF

    WebMock
      .stub_request(:post, "#{Setting.instance.mip}/QueueServer/1.0/Services/numbercount")
      .to_return(body: total_xml_res)
    WebMock
      .stub_request(:post, "#{Setting.instance.mip}/QueueServer/1.0/Services/passcount")
      .to_return(body: pass_xml_res)
  end

  test 'should store total number count' do
    handler = SyncHandler.new
    @scheduler.schedule_in('0s', handler)
    sleep 0.4

    assert Setting.total_number_count, 17
  end

  test 'should store pass number count' do
    handler = SyncHandler.new
    @scheduler.schedule_in('0s', handler)
    sleep 0.4

    assert Setting.pass_number_count, 4
  end
end
