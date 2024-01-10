Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :employees, controllers: {
                           sessions: 'employees/sessions',
                           passwords: 'employees/passwords',
                           registrations: 'employees/registrations',
                           unlocks: 'employees/unlocks',
                           confirmations: 'employees/confirmations',
                           invitations: 'employees/invitations'
                       }

  as :employee do
    get 'login', to: 'devise/sessions#new', as: :user_login
    delete 'logout', to: 'devise/sessions#destroy', as: :user_logout
    get 'registration', to: 'devise/registrations#new', as: :company_registration
  end

  post '/submit_contact', to: 'home#submit_contact', as: :submit_contact
  get '/email_template', to: 'home#email_template'
  post '/email_subscribe', to: 'home#email_subscribe', as: :email_subscribe
  get '/watch_video/:module', to: 'home#watch_video', as: :watch_video

  get '/terms-and-conditions', to: 'home#terms_and_conditions'
  get '/pricing', to: 'home#pricing'
  get '/take-a-tour', to: 'home#take_a_tour'
  get '/contact-us', to: 'home#contact_us', as: :contact_us
  get 'modules/employee', to: 'home#employee'
  get 'modules/leave', to: 'home#leave'
  get 'modules/attendance', to: 'home#attendance'
  get 'modules/payroll', to: 'home#payroll'
  get 'modules/provident_fund', to: 'home#provident_fund'
  get 'modules/expense', to: 'home#expense'
  get 'modules/bank', to: 'home#bank'
  post '/feedback', to: 'home#feedback', as: :feedback

  namespace :community do
    root :to => 'posts#index'
    resources :posts
    resources :comments, only: [:create]
  end

  namespace :employees do
    resources :advances do
      get :employee_advances, on: :collection
      get :history, on: :collection
    end
    resources :advance_returns
  end

  # For employee resources
  resources :employees do
    get :attendances
    get :settings
    post :import, on: :collection
    get :profile
    get :download_templete, on: :collection
    post :add, on: :collection
    put :update_info, on: :member
    get :access_rights, on: :collection
    patch :update_password, on: :collection
    put :activation, on: :member
    get :payroll_categories, on: :member
    get :increments, on: :member
    get :identity_attachment, on: :member
    get :card
  end

  get '/confirm_email', to: 'employees#confimed_email_error'
  resources :access_rights


  resources :departments do
    get :switch, on: :member
    get :all_settings, on: :member
    member do
      scope :settings do
        get :employee
        get :leave
        get :budget
        get :general
        get :attendance
        get :designation
      end
    end
  end

  resources :settings do
    get :confirm, on: :collection
    get :features, on: :collection
    get :billing, on: :collection
    post :payment_method, on: :collection
    post :company_feature, on: :collection
  end

  namespace :leave do
    get :dashboard
    resources :applications do
      get :leave_status, on: :collection
      get :report, on: :collection
      get :summary, on: :collection
      get :leave_calendar, on: :collection
      get :reject_application, on: :collection
      get :approve_application, on: :collection
      get :download, on: :collection
      get :employee_status, on: :collection
      get :leave_attachment, on: :member
    end
    resources :categories, except: [:index] do
      get :activate, on: :member
      get :deactivate, on: :member
    end
    resources :category_years
  end

  namespace :attendance do
    get :dashboard
    resources :attendances do
      get :history, on: :collection
      get :report, on: :collection
      get :employee_wise_report, on: :collection
      get :in, on: :collection
      get :out, on: :member
      get :stats, on: :collection
    end
    resources :day_offs do
      post :generate, on: :collection
    end
  end

  resources :designations, except: [:index]

  resources :companies do
    get :profile, on: :collection
    get :employee, on: :collection
    get :departments, on: :collection
  end

  namespace :expense do
    get :dashboard
    get :summary
    get :compare
    get :yearly
  end

  namespace :expenses do
    resources :budgets do
      get :get_budget, on: :collection
      get :update_budget, on: :collection
    end
    resources :categories do
      get :sub_categories, on: :member
    end
    resources :expenses do
      get :attachment_view, on: :member
      get :approve_reject, on: :member
      get :report, on: :collection
      get :report_breakdown, on: :collection
      get :monthly_report, on: :collection
      get :category_wise_report, on: :collection
    end
  end

  namespace :payroll do
    get :dashboard
    get :summary
    resources :categories do
      post :setup, on: :collection
    end
    resources :employee_categories, except: [:index, :show]
    resources :increments do
      get :accept, on: :member
    end
    resources :salaries do
      get :process_salary, on: :collection, as: :process_salary
      post :process_all, on: :collection, as: :process_all
      get :payable_employees, on: :collection
      get :unconfirmed_salaries, on: :collection
      get :confirm, on: :collection
      get :update_salary_status, on: :member
      get :monthly_sheet, on: :collection
      get :combined_salary_report, on: :collection
      get :process_combined_salary, on: :collection
      get :payable_departments, on: :collection
      post :process_all_combined_salary, on: :collection
      get :department_unconfirmed_salaries, on: :collection
      get :confirm_departments, on: :collection
    end
    resources :increments
    resources :salaries do
      get :payslip
    end
    resources :bonus_categories
    resources :bonus_payments
  end

  namespace :provident_fund do
    get :dashboard
    get :statement
    resources :rules
    resources :investments
    resources :loans do
      get :history, on: :collection
    end
    resources :loan_returns do
      collection do
        get :return_form
      end
    end
    resources :accounts do
      get :employee, on: :collection
      get :statement
      resources :contributions
    end
    resources :contributions, only: [] do
      get :employee_contributions, on: :collection
      get :process_contribution, on: :collection
      post :confirm, on: :collection
    end
  end

  namespace :bank do
    resources :accounts
  end

  namespace :billing do
    get :dashboard
    resources :clients
    resources :invoices do
      collection do
        get 'filter_invoices'
        get 'bulk_actions'
        get 'undo_actions'
        post 'duplicate_invoice'
        get 'enter_single_payment'
        get 'send_invoice'
        post 'paypal_payments'
        get 'paypal_payments'
        post 'preview'
        get 'preview'
        get 'credit_card_info'
        get 'selected_currency'
        get 'unpaid_invoices'
      end
      get :invoice_pdf
      resources :payments
    end
    resources :payments do
      collection do
        get :enter_payment
      end
      member do
        get :payment_report
        get :download_payment_report
      end
    end
  end

  namespace :daily_progress do
    get :dashboard
    get :my_report
    get :progress_reports
    get :compare_progress
    resources :tasks do
      collection do
        post :batch_update
        get :import_backlog
        get :add_from_backlog
      end
    end
  end

  resources :remarks

  resources :changed_settings, only: [:new, :create, :edit, :update, :destroy]

  # You can have the root of your site routed with "root"
  root 'home#index'

  %w( 404 422 500 503 ).each do |code|
    get code, :to => 'errors#show', :code => code
  end

  get '/*other', :to => 'errors#show', :code => 404
end
