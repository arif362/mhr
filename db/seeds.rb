# # This file should contain all the record creation needed to seed the database with its default values.
# # The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
# #
# # Examples:
# #
# #   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
# #   Mayor.create(name: 'Emanuel', city: cities.first)
# # Feature.create(name: 'Salary', description:'It will help to provide generate salary', cost: 299, module:'employee::salary')
#
# Department.all.each do |dp|
#   designation = dp.designations.create(name: Faker::Company.name)
#   15.times.each do
#     dp.employees.create(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: Faker::Internet.email, mobile: Faker::PhoneNumber.phone_number, address: Faker::Address.secondary_address, password: '123456789', designation_id: designation.id)
#   end
# end
# Department.all.each do |dp|
#   dp.employees.each do |em|
#     5.times.each do
#       leave_category= dp.leave_categories.create(name: Faker::Name.name, days: Faker::Number.between(1,10))
#       em.leave_applications.create(message: Faker::Lorem.paragraph,department_id: dp.id,leave_category_id: leave_category.id )
#     end
#   end
# end
#
# Leave::Application.all.each do |la|
#   3.times.each do
#     la.leave_days.create(day: Faker::Date.forward(2))
#   end
# end
#
# Department.all.each do |dp|
#   3.times.each do
#     category = dp.expenses_categories.create(name: Faker::Name.name, description: Faker::Lorem.paragraph)
#     2500times.each do
#       sub_cat = category.expense_sub_categories.create(name: Faker::Name.name, description: Faker::Lorem.paragraph, department_id: dp.id)
#       3.times.each do
#         category.expenses.create(description: Faker::Lorem.paragraph, amount: Faker::Number.between(100,200), department_id: dp.id, date: Date.today, expense_sub_category_id: sub_cat.id)
#       end
#     end
#   end
# end
#
# Department.all.each do |dp|
#   5.times.each do
#     dp.payroll_categories.create(name: Faker::Name.name, description: Faker::Lorem.paragraph)
#   end
#
#   dp.employees.each do |emp|
#     5.times.each do
#       emp.payroll_increments.create(department_id: dp.id, incremented_by: Faker::Name.name, present_basic: Faker::Number.between(5000,6000), previous_basic: Faker::Number.between(6000,7000), increment_amount: Faker::Number.number(4), is_active: false, active_date: Date.today)
#     end
#   end
# end
#
# Department.all.each do |dp|
#   dp.employees.each do |emp|
#     5.times.each do
#       emp.payroll_salaries.create()
#     end
#   end
# end


# Feature.delete_all
Feature.create!(name: 'Attendance', cost: 2500, description: 'The attendence is an activity module for tracking time spent by Employees.', app_module: 'Attendance', url: '/attendance/dashboard', logo: 'module_settings/attendance.png')
Feature.create!(name: 'Leave', cost: 2500, description: 'MHR has a global leave module-it can set leave system for any firm.', app_module: 'Leave', url: '/leave/dashboard', logo: 'module_settings/leave.png')
Feature.create!(name: 'Payroll', cost: 2500, description: 'Payroll is the sum of all financial records of salaries for an employee.', app_module: 'Payroll', url: '/payroll/dashboard', logo: 'module_settings/payroll.png')
Feature.create!(name: 'Expense', cost: 2500, description: 'Expense will allow you to monitor costs before your employees.', app_module: 'Expenses', url: '/expenses/expenses', logo: 'module_settings/expense.png')
Feature.create!(name: 'Provident Fund', cost: 2500, description: 'Provident Fund is designed to process and provide all.', app_module: 'ProvidentFund', url: '/provident_fund/dashboard', logo: 'module_settings/provident_fund.png')
Feature.create!(name: 'Inventory', cost: 2500, description: 'Provident Fund is designed to process and provide all.', app_module: 'Inventory', url: '#', logo: 'module_settings/inventory_management.png')
Feature.create!(name: 'Bank', cost: 2500, description: 'Bank is designed to process and provide all.', app_module: 'Bank', url: '/bank/accounts', logo: 'module_settings/provident_fund.png')
Feature.create!(name: 'Daily Progress', cost: 2500, description: 'Daily Progress is designed to keep track of daily tasks of employees and provide all.', app_module: 'DailyProgress', url: '/daily_progress/dashboard', logo: 'module_settings/daily_progress.png')

# CompanyFeature.delete_all
#
# Community::Category.delete_all
# Feature.all.each do |feature|
#   Community::Category.create!(title: feature.name, description: feature.description)
# end

# Feature.find_by_app_module('Expense').update_attributes(app_module: 'Expenses')

AdminUser.create!(email: 'admin@mihisoft.com', password: 'password', password_confirmation: 'password') if Rails.env.development?