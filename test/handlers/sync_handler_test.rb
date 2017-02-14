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

    servingnumber_rsp = <<-EOF
      <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
      <Package>
      <RspCode>0</RspCode>
      <RspMsg>处理成功</RspMsg>
      <QueueNumber>A121</QueueNumber>
      <Servesingletype>0</Servesingletype>
      <Qcount>0</Qcount>
      <MarkScore>0</MarkScore>
      </Package>
    EOF

    stub_request(:post, "#{Setting.instance.mip}/QueueServer/1.0/Services/numbercount")
      .to_return(body: total_xml_rsp)
    stub_request(:post, "#{Setting.instance.mip}/QueueServer/1.0/Services/passcount")
      .to_return(body: pass_xml_rsp)
    stub_request(:post, "#{Setting.instance.mip}/QueueServer/1.0/Services/servingnumber")
      .to_return(body: servingnumber_rsp)

    @scheduler = Rufus::Scheduler.new
  end

  teardown do
    @scheduler.shutdown
  end

  test 'should store total number count' do
    job = @scheduler.in('0s', SyncHandler.new, job: true)
    job.call
    assert_equal Setting.total_number_count.to_i, 17
  end

  test 'should store pass number count' do
    job = @scheduler.in('0s', SyncHandler.new, job: true)
    job.call
    assert_equal Setting.pass_number_count.to_i, 4
  end

  test 'should sync serving_number of every counter' do
    business_category = FactoryGirl.create :business_category
    counter = BusinessCounter.create number: 3, business_category: business_category
    job = @scheduler.in('0s', SyncHandler.new, job: true)
    job.call
    assert_equal counter.reload.serving_number, 'A121'
  end
end
