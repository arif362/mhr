class SalaryCreatedJob < Struct.new(:department, :year, :month, :employees)

  def perform
    puts("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<,,,,")
    employees.each do |employee_id|
      employee = Employee.find_by_id(employee_id)
      salaries = employee.payroll_salaries.where(month: month.to_i, year: year.to_i)
      unless salaries.present?
        salary = Payroll::Salary.process(department, employee, month.to_i, year.to_i)
        salary.is_confirmed = false
        salary.save!
      end
    end
    puts("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<,,,,")
  end

  def enqueue(job)
    job.source_id = department.id
    job.save
  end

end
