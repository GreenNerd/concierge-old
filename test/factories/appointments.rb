FactoryGirl.define do
  factory :appointment do
    appoint_at        { Availability.next_available_dates(days: 1).first }
    business_category nil
    id_number         { 432831196411150810 }
    openid            { rand(10000) }
    phone_number      { 18612345678 + rand(10000) }
    expired           false
  end
end
