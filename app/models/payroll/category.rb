# == Schema Information
#
# Table name: payroll_categories
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  description   :text(65535)
#  department_id :integer
#  is_add        :boolean          default(TRUE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  is_percentage :boolean          default(TRUE)
#

module Payroll
  class Category < Base
    belongs_to :department

    has_many :payroll_employee_categories, class_name: 'Payroll::EmployeeCategory', dependent: :destroy
    has_many :employees, through: :payroll_employee_categories

    accepts_nested_attributes_for :employees
    validates_uniqueness_of :name, scope: :department_id
    validates_presence_of :name
  end
end
