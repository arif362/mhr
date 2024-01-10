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

FactoryGirl.define do
  factory :access_right do
    permissions {{ 'access_right'=> '3','department'=> '3','designation'=> '3','employee'=> '3','leave_application'=> '3','setting'=> '3','leave_category'=> '3','attendance'=> '3','day_off'=> '3'}}
  end
end
