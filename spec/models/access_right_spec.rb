# == Schema Information
#
# Table name: access_rights
#
#  id                 :integer          not null, primary key
#  employee_id        :integer
#  permissions        :text(65535)
#  custom_permissions :text(65535)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'rails_helper'

RSpec.describe AccessRight, type: :model do
  # before(:each) do
  #   @employee = FactoryGirl.create(:employee)
  #   @access_right = FactoryGirl.create(:access_right, employee_id: @employee.id)
  # end
  #
  # describe 'instance method #get_permission_type' do
  #   it 'should return ' do
  #
  #   end
  # end

end
