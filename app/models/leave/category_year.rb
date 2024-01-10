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

module Leave
  class CategoryYear < Base
    belongs_to :department
    belongs_to :leave_category, :class_name => 'Leave::Category', foreign_key: :leave_category_id

    def self.search(department, year)
      self.where(department_id: department.id, year: year)
    end

    def self.hashed_items(department_id, leave_categories, year)
      leave_category_years = {}
      leave_categories.each do |leave_category|
        leave_category_years[leave_category.id] = {
            leave_category: leave_category,
            days: nil,
            category_year: nil
        }
      end
      category_years = self.where(department_id: department_id, year: year)
      category_years.each do |category_year|
        leave_category_years[category_year.leave_category_id][:days] = category_year.days
        leave_category_years[category_year.leave_category_id][:category_year] = category_year
      end
      leave_category_years
    end

    def self.hashed_item(leave_category, no_of_days, category_year)
      {
          leave_category: leave_category,
          days: no_of_days,
          category_year: category_year
      }
    end
  end
end
