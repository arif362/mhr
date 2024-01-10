# == Schema Information
#
# Table name: profile_pictures
#
#  id          :integer          not null, primary key
#  employee_id :integer
#  image       :string(255)
#  is_active   :boolean
#

require 'rails_helper'

RSpec.describe ProfilePicture, type: :model do

end
