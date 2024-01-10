module DailyProgress
  class TasksController < ApplicationController
    before_filter :current_ability
    before_action :set_task, only: [:edit, :update, :destroy]
    before_action :set_date, only: [:batch_update, :index, :new, :create, :import_backlog, :add_from_backlog]

    def index
      @tasks = current_employee.task_of(@date)
    end

    def import_backlog
      respond_to do |format|
        @backlog_tasks = current_employee.daily_progress_tasks.where.not(is_complete:true, date: @date)
        format.js
      end
    end

    def show
    end

    def new
      respond_to do |format|
        @task = Task.new
        @tasks = current_employee.task_of(@date)
        format.js
      end
    end

    def edit
    end

    def create
      if params[:daily_progress_task][:multi_tasks] == '1'
        @multiple_new_tasks =  params[:daily_progress_task][:title].split("\n")
      end
      if @multiple_new_tasks.present?
        @m_tasks = multiple_tasks = {}
        @multiple_new_tasks.each do |task|
          new_task = current_employee.daily_progress_tasks.create(title: task, date: @date, is_complete: false)
          if new_task.save
            multiple_tasks[new_task.id] = new_task
          end
        end
        multiple_tasks
      else
        @task = current_employee.daily_progress_tasks.build(task_params.merge({date: @date, is_complete: false}))
        @task.save
      end
      respond_to do |format|
        format.js {}
        format.html { redirect_to @task, notice: 'Task was successfully created.' }
        format.json { render :show, status: :created, location: @task }
      end
    end

    def update
      respond_to do |format|
        if @task.update(task_params)
          format.js {}
          format.json { render :show, status: :ok, location: @task }
        else
          format.html { render :edit }
          format.json { render json: @task.errors, status: :unprocessable_entity }
        end
      end
    end

    def batch_update
      tasks = current_employee.task_of(@date)
      if params[:completed].present?
        tasks.each do |task|
          task.is_complete = false
          task.is_complete = params[:completed].include? task.id.to_s
          task.save
        end
        flash[:notice] = "Your daily progress updated"
      else
        flash[:danger] = "You have not selected any tasks to update."
      end
      redirect_to daily_progress_tasks_path(date: @date)
    end

    def add_from_backlog
      if params[:completed].present?
        backlog_tasks = DailyProgress::Task.add_task(params[:completed], current_employee, @date)
        flash[:notice] = "tasks imported successfully."
      else
        flash[:danger] = "You have not selected any tasks to import."
      end
      redirect_to daily_progress_tasks_path(date: @date)
    end

    def destroy
      @task.destroy
      respond_to do |format|
        format.html { redirect_to tasks_url, notice: 'Task was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    def set_date
      @date = params[:date] || Date.today.to_s
      @next_day = Date.parse(@date) + 1
      @prev_day = Date.parse(@date) - 1
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:daily_progress_task).permit(:title, :multi_tasks, :employee_id, :date, :is_complete)
    end
  end
end
