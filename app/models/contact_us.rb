# == Schema Information
#
# Table name: contact_us
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  subject    :text(65535)
#  message    :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ContactUs < ActiveRecord::Base
  validates_presence_of :name, :email
end
