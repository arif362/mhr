# == Schema Information
#
# Table name: companies
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  image         :string(255)
#  employee_id   :integer
#  mobile        :string(255)
#  contact_email :string(255)
#  address       :string(255)
#  city          :string(255)
#  state         :string(255)
#  zip_code      :string(255)
#  country       :string(255)
#  next_path     :string(255)
#  custom_url    :string(255)
#  url           :string(255)
#

class Company < ActiveRecord::Base
  mount_uploader :image, LogoUploader
  belongs_to :employee
  has_many :departments, dependent: :destroy
  has_many :company_features, dependent: :destroy
  has_many :features, through: :company_features
  has_many :expenses_budgets, :class_name => 'Expenses::Budget', dependent: :destroy
  validates_presence_of :name, :mobile, :address, :zip_code, :country

  def taken_features
    modules_name = []
    features.each do |feature|
      modules_name.push(feature.name)
    end
    modules_name
  end

  def sidebar_menu_generator
    {
        title: 'Company Settings',
        tooltip: 'Company Settings',
        menus: [
            {title: 'Information', url: '/companies/profile', icon: 'fa-info-circle', class: 'information sidebar-menu-active', tooltip: 'Information'},
            {title: 'Departments', url: '/companies/departments', icon: 'fa-user-circle', class: 'department', tooltip: 'Departments'},
            {title: 'Employees', url: '/companies/employee', icon: 'fa-users', class: 'employee', tooltip: 'Employees'},
            {title: 'Settings', url: '/settings', icon: 'fa-cog', class: 'settings', tooltip: 'Settings'},
        ]
    }
  end
end
