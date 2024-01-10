# == Schema Information
#
# Table name: profile_pictures
#
#  id          :integer          not null, primary key
#  employee_id :integer
#  image       :string(255)
#  is_active   :boolean
#

class ProfilePicture < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  belongs_to :employee
end
