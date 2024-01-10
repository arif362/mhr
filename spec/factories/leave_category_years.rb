# == Schema Information
#
# Table name: leave_category_years
#
#  id                :integer          not null, primary key
#  department_id     :integer
#  leave_category_id :integer
#  year              :integer
#  days              :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

FactoryGirl.define do
  factory :leave_category_year, class: 'Leave::CategoryYear' do
    year 2017
    days 5
  end
end
