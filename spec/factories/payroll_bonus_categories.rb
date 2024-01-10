# == Schema Information
#
# Table name: payroll_bonus_categories
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  is_amount     :boolean          default(TRUE)
#  amount        :float(24)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  department_id :integer
#  message       :text(65535)
#

FactoryGirl.define do
  factory :payroll_bonus_category, class: 'Payroll::BonusCategory' do
    name 'eid-ul-fitor'
  end
end
