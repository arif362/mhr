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

require 'rails_helper'

RSpec.describe Leave::CategoryYear, type: :model do

  before(:each) do
    @company = FactoryGirl.create(:company)
    @department = FactoryGirl.create(:department, company_id:@company.id)
    @leave_category = FactoryGirl.create(:leave_category, department_id:@department.id)
    @leave_category_year = FactoryGirl.create(:leave_category_year, department_id:@department.id, leave_category_id:@leave_category.id)
    @year = Date.today.year
  end

  describe 'class method#search' do
    it 'should return category year' do
      expect(Leave::CategoryYear.search(@department, @year)).to eq(Leave::CategoryYear.where(department_id: @department.id, year: @year))
    end
  end

end
