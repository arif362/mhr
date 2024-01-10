FactoryGirl.define do
  factory :expenses_expense, class: Expenses::Expense do
    description Faker::Lorem.sentences
    amount 800
    date Date.today
    is_approved false
    received_by Faker::Name.name
    payment_method 'Cash'
    status AppSettings::REMARK_STATUS[:pending]
  end
end
