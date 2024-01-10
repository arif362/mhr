ActiveAdmin.register CompanyFeature do
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

  controller do

    def permitted_params
      params.permit!
    end

    def create
      create! { |success, failure|
        success.html do
          redirect_to :back, :notice => "Resource created successfully."
        end
        failure.html do
          flash[:error] = "Error(s) : #{resource.errors.full_messages.join(',')}"
          redirect_to :back
        end
      }
    end
  end

  show do
    attributes_table do
      row :id
      row :feature do |company_feature|
        company_feature.feature.name
      end
      row :company do |company_feature|
        company_feature.company.name
      end
      row :created_at
      row :updated_at
    end
  end

end
