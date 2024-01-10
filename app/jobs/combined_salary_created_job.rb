class CombinedSalaryCreatedJob < Struct.new(:company, :year, :month, :department_ids)

  def perform
    puts("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<,,,,")
    department_ids.each do |department_id|
      department = Department.includes(:employees).find_by_id(department_id)
      employees = department.employees.where('invitation_token IS NULL and is_active = true')

      employees.each do |employee|
        salaries = employee.payroll_salaries.where(month: month.to_i, year: year.to_i)
        unless salaries.present?
          salary = Payroll::Salary.process(department, employee, month.to_i, year.to_i)
          salary.is_confirmed = false
          salary.from_combined = true
          salary.save!
        end
      end
    end
    puts("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<,,,,")
  end

  def enqueue(job)
    job.source_id = company.id
    job.save
  end

end
