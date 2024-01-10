ActiveAdmin.register Feature do
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

  end

  index do
    selectable_column
    id_column
    column :name
    column :cost
    column :description
    column :app_module
    column :url
    column :logo
    actions
  end

show do
  attributes_table do
  row :name
  row :cost
  row :description
  row :app_module
  row :url
  row :logo
    end

end
end



