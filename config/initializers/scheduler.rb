require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new
#scheduler = Rufus::Scheduler.singleton

# scheduler.every '1m', :first_in => '3s' do
#   Department.all.each do |department|
#     salary_changes = department.payroll_increments.where("active_date <= ? AND is_active = ? ", Date.today , false)
#     salary_changes.each do |history|
#       employee = department.employees.find_by_id(history.employee_id)
#       employee.change_employee_salary(history)
#     end
#   end
# end

scheduler.cron '00 00 * * *' do
  Department.all.each do |department|
    salary_changes = department.payroll_increments.where('active_date <= ? AND is_active = ?', Date.today , false)
    salary_changes.each do |history|
      employee = department.employees.find_by_id(history.employee_id)
      employee.change_employee_salary(history)
    end
  end
end