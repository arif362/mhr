# == Schema Information
#
# Table name: designations
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  description   :text(65535)
#  is_active     :boolean          default(FALSE)
#  department_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Designation < ActiveRecord::Base
  belongs_to :department
  has_many :employees, dependent: :destroy
  before_destroy :check_for_employee

  validates_presence_of :name
  validates_uniqueness_of :name, scope: :department_id

  private

  def check_for_employee
    if employees.count > 0
      errors[:base] << "Cannot delete designation as used employee's designation"
      return false
    end
  end
end
