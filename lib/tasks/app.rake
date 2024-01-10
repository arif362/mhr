namespace :app do
  task :user_color_code => :environment do
    Employee.all.each do |emp|
      color = '#' + SecureRandom.hex(3)
      emp.update_attribute(:color, color)
    end
  end
end