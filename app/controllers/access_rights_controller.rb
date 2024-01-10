class AccessRightsController < InheritedResources::Base
  before_filter :current_ability
  
  def update
    @access_right = AccessRight.find_by_id(params[:id])
    @access_right.update_attributes(access_right_params)
  end

  def add_remove_notification_access
     if params[:todo] == 'add'
       current_department.notification_accesses.find_or_create_by(employee_id: params[:employee_id], notification_type: params[:access_type])
     else
       notification_type = current_department.notification_accesses.where(employee_id: params[:employee_id], notification_type: params[:access_type]).first
       if notification_type.present?
         notification_type.delete
       end
     end
  end

  def notification_type_list
    @notication_types = Notification::NOTIFICATION_TYPE
  end

  private
  
  def access_right_params
    params.require(:access_right).permit(:employee_id, 
      :permissions => AccessRight::PERMISSION_LIST, 
      :custom_permissions => AccessRight::CUSTOM_PERMISSION_LIST)
  end
end
