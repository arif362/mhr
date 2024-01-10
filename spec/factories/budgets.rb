FactoryGirl.define do
  factory :budget, class: Expenses::Budget do
    category_id 1
    department_id 1
    company_id 1
    year 1
    amount 1.5
  end
end
