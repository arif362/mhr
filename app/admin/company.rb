ActiveAdmin.register Company do
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
  controller do
    def permitted_params
      params.permit!
    end
  end

  index do
    selectable_column
    id_column
    column :name
    column :employee
    column :mobile
    column :contact_email
    column :address
    column :city
    column :state
    column :zip_code
    column :country do |company|
      country_name(company)
    end
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :image
      row :employee
      row :mobile
      row :contact_email
      row :address
      row :city
      row :state
      row :zip_code
      row :country do |company|
        country_name(company)
      end
      row :next_path
      row :custom_url
      row :url
    end

    panel "Taken Modules (#{company.features.count})" do
      ul do
        company.features.each do |feature|
          li do
            feature.name
          end
        end
      end
    end

    panel "Departments (#{company.departments.count})" do
      table_for company.departments do
        column :id
        column :name
        column :mobile
        column :email
        column :address
        column :city
        column :state
        column :zip_code
        column :country do |department|
          country_name(department)
        end
      end
    end

  end
end
