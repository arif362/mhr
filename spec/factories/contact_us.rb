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

FactoryGirl.define do
  factory :contact_u do
    name "MyString"
    email "MyString"
    subject "MyText"
    message "MyText"
  end
end
