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

module Leave
  class Category < Leave::Base
    belongs_to :department
    has_many :leave_applications, :class_name => 'Leave::Application', foreign_key: :leave_category_id, dependent: :destroy
    has_many :leave_category_years, :class_name => 'Leave::CategoryYear', foreign_key: :leave_category_id, dependent: :destroy
    validates_presence_of :name
    validates_uniqueness_of :name, scope: :department_id

    def self.total_leave_days(year)
      self.joins(:leave_category_years).where('leave_category_years.year = ?', year).sum('leave_category_years.days')
    end

    def self.active
      self.where(is_active: true)
    end

    def self.of_the_year(year)
      self.joins(:leave_category_years).where('leave_category_years.year = ?', year)
    end

    def days(year)
      leave_category_years.where(year: year).sum(:days) || 0
    end
  end
end
