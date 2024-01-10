json.array!(@leave_applications) do |leave_application|
  json.extract! leave_application, :id, :message, :note, :attachment, :is_approved, :employee_id, :leave_category_id
  json.url leave_application_url(leave_application, format: :json)
end
