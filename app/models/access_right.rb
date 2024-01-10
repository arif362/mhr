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

class AccessRight < ActiveRecord::Base
  serialize :permissions, Hash
  serialize :custom_permissions, Hash

  PERMISSION_LIST ={
     'AccessRight' => [ :access_rights ] ,
     'Company' => [ :companies ] ,
     'Department' => [ :departments ] ,
     'Designation' => [ :designations ] ,
     'Remark' => [:remarks],
     'Setting' => [ :settings ] ,
     'Employees' => [:advance_returns, :advances, :employees] ,
     'Attendance' => [ :attendance, :attendances, :day_offs ] ,
     'Expenses' => [:expense, :categories, :expenses] ,
     'Payroll' => [:payroll, :bonus_categories, :bonus_payments, :categories, :employee_categories, :increments, :salaries ] ,
     'ProvidentFund' => [:provident_fund , :accounts, :contributions, :investments, :loan_returns, :loans, :rules],
     'Leave' => [:leave, :applications, :categories, :category_years ] ,
     'Bank' => [:accounts],
     'DailyProgress' => [:daily_progress, :tasks]
  }


  CUSTOM_PERMISSION_LIST = [
      :cheque_deposit_notice
  ]

  PERMISSION_TYPES = [
      ["No Access", 0],
      ["Read only access", 1],
      ["Add / edit / other custom action", 2],
      ["Full access including delete", 3]
  ]

  CUSTOM_PERMISSION_TYPES = [
      ["No Access", 0],
      ["Can Access", 1]
  ]

  belongs_to :employee

  def get_permission_type(value)
    temp = PERMISSION_TYPES.select { |item| item[1] == value.to_i }
    temp.first[0] if temp.present?
  end

  def get_custom_permission_type(value)
    temp = CUSTOM_PERMISSION_TYPES.select { |item| item[1] == value.to_i }
    temp.first[0] if temp.present?
  end
end
