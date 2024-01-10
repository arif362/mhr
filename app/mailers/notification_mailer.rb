class NotificationMailer < ApplicationMailer
  layout false, only: 'company_welcome'

   def leave_application(leave_application)
     @leave_application = leave_application
     mail(to: 'gmarifulislamarif@gmail.com', subject: 'New Leave Application', from: leave_application.employee.email)
   end

   def employee_advance(advance)
     @advance = advance
     mail(to: advance.employee.email, subject: 'Advance received')
   end

   def employee_advance_return(advance_return)
     @advance_return = advance_return
     mail(to: advance_return.employee.email, subject: 'Advance return')
   end

   def salary_receipt(salary)
     @salary = salary
     @employee = @salary.employee
     @right_border = ' '
     @left_border = ' '
     if @salary.addition_category.size + 1 > @salary.deduction_category.size
       @right_border = 'border-right: solid 1px #333333;'
     else
       @left_border = 'border-left: solid 1px #333333;'
     end
     mail(to: salary.employee.email, subject: 'Payslip')
   end

   def company_welcome(employee)
     @company_owner_new = employee
     mail(to: employee.email, subject: 'Welcome to MHR')
     render layout: false
   end

   def company_created_notice(employee, company)
     @company_owner_new = employee
     @new_company = company
     mail(to: 'gmarifulislamarif@gmail.com', subject: 'Company Creation Notice!!')
   end

end
