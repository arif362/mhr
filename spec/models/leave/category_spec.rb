# == Schema Information
#
# Table name: leave_categories
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  department_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  description   :text(65535)
#  is_active     :boolean          default(TRUE)
#

require 'rails_helper'

RSpec.describe Leave::Category, type: :model do
  before(:each) do
    @company_owner = FactoryGirl.create(:employee)
    @company = FactoryGirl.create(:company, employee_id:@company_owner.id)
  end
  # before(:each) do
  #   @company = FactoryGirl.create(:company)
  #   @department =  FactoryGirl.create(:department, company_id: @company.id)
  #   @employee = FactoryGirl.create(:employee, department_id: @department.id)
  #   @leave_category_1 = FactoryGirl.create(:leave_category, days: 5, department_id: @department.id)
  #   @leave_category_2 = FactoryGirl.create(:leave_category, days: 5, department_id: @department.id)
  # end
  #
  # describe 'Leave::Category #total_leave_days' do
  #   it "should return total leave days of a department" do
  #     expect(Leave::Category.total_leave_days(@department)).to eq(10)
  #   end
  # end
end
