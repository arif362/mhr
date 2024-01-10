# == Schema Information
#
# Table name: tasks
#
#  id                 :integer          not null, primary key
#  title              :string(255)
#  employee_id        :integer
#  date               :date
#  is_complete        :boolean
#  created_at         :datetime
#  updated_at         :datetime
#  is_backlog_updated :boolean          default(FALSE)
#  forward_to_date    :date
#  forward_from_date  :date
#

module DailyProgress
  class Task < ActiveRecord::Base
    belongs_to :employee
    validates_presence_of :title

    attr_accessor :multi_tasks


    def self.add_task(task_ids, current_employee, date)
      task_ids.each do |backlog_task_id|
        task = Task.find_by(id: backlog_task_id)
        if task.present?
          task.update_attributes(is_complete:true, is_backlog_updated:true, forward_to_date: date)
          new_task = current_employee.daily_progress_tasks.create!(title: task.title, date: date, is_complete: false, forward_from_date: task.date)
        end
      end
    end

  end
end
