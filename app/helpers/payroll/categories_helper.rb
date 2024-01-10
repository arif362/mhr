module  Payroll
  module CategoriesHelper
    def salary_categories(employee)
      current_department.payroll_categories.to_a - employee.payroll_categories.to_a
    end
  end
end