json.array!(@attendances) do |attendance|
  json.extract! attendance, :id, :in_date, :in_time, :out_time, :duration, :user_id
  json.url attendance_url(attendance, format: :json)
end
