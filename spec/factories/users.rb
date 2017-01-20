FactoryGirl.define do
  factory :user do
    first_name "MyString"
    last_name "MyString"
    cellphone "MyString"
    birthday "2017-01-20"
    sex "MyString"
    nautical_professional 1
    academic_profile "MyText"
    relationship 1
    user nil
    about "MyText"
    has_embarcation 1
    nautical_work "MyText"
    naval_service "MyText"
  end
end
