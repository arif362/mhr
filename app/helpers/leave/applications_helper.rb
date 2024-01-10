module Leave
  module ApplicationsHelper
    def leave_taken(leaves, category_id)
      leaves.where(is_approved: true, leave_category_id: category_id).sum(:total_days)
    end

    def paid_leave_taken(leaves, category_id)
      leaves.where(is_approved: true, leave_category_id: category_id, is_paid: true).sum(:total_days)
    end

    def application_dates(leave_application)
      result = ""
      leave_application.leave_days.each do |leave_day|
        result += ", " if result.present?
        if leave_day.is_approved
          result += leave_day.day.strftime('%d %B')
        else
          result += "<span style='color:red'>#{leave_day.day.strftime('%d %B')}</span>"
        end
      end
      raw result
    end
  end
end
