FactoryGirl.define do
  factory :appointment do
    appoint_at        '2017-2-9'
    business_category nil
    id_number         '510123123111231231'
    openid            'abcdefghigklmn'
    phone_number      '18612345678'
    queue_number      'A001'
    expired           false
  end
end
