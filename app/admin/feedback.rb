ActiveAdmin.register Feedback do
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

  index do
    selectable_column
    id_column
    column :name
    column :email
    column :comments
    column 'Design' do |feed|
      "#{(feed.design)} / 4"
    end
    column 'Response' do |feed|
      "#{(feed.response)} / 4"
    end
    column 'Ratting' do |feed|
      "#{(feed.rate)} / 4"
    end
    actions
  end

  show do
    attributes_table do
      row :name
      row :email
      row :comments
      row 'Design' do |feed|
        "#{(feed.design)} / 4"
      end
      row 'Response' do |feed|
        "#{(feed.response)} / 4"
      end
      row 'Ratting' do |feed|
        "#{(feed.rate)} / 4"
      end
    end
  end

end
