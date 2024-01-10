ActiveAdmin.register Employee do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end
  actions :all, :except => [:new]
  index do
    selectable_column
    id_column
    column :email
    column :first_name
    column :last_name
    column :nid
    column :department do |employee|

      employee.department.name if employee.department.present?
    end
    column :login_as do |employee|
      link_to "Login", login_as_admin_employee_path(employee)
    end
    actions
  end

  show do
    attributes_table do
      row :id
      row :email
      row :first_name
      row :last_name
      row :note
      row :location
      row :dob
      row :address
      row :gender
      row :basic_salary
      row :mobile
      row :nid
      row :kin_name
      row :kin_contact
      row :is_active
      row :image
      row :department do |employee|
        employee.department.name
      end
      row :role
      row :blood_group
      row :joining_date
      row :designation do |employee|
        employee.designation.name if employee.designation.present?
      end

      row :created_at
      row :updated_at
    end
  end

  member_action :login_as, :method => :get do
    sign_out current_admin_user
    sign_in(:employee, Employee.find(params[:id]), { :bypass => true })
    redirect_to root_path
  end

end
