FactoryGirl.define do
  factory :setting do
    inst_no '10101'
    term_no 'ZZZD-0001'
    counter_counter 1
    enable false
    mip 'http://192.168.18.88:8080'
    limitation 10
    appoint_begin_at '00:00'
    appoint_end_at '24:00'
  end
end
