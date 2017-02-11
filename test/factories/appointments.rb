FactoryGirl.define do
  factory :appointment do
    appoint_at        { Availability.next_available_dates(days: 1).first }
    business_category nil
    id_number         '510123123111231231'
    openid            'abcdefghigklmn'
    phone_number      '18612345678'
    expired           false
  end
end
