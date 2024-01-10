# == Schema Information
#
# Table name: feedbacks
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  design     :integer
#  response   :integer
#  functional :integer
#  overall    :integer
#  rate       :float(24)
#  comments   :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :feedback do
    name "MyString"
    email "MyString"
    design ""
    response 1
    functional 1
    overall 1
    rate 1.5
    comments "MyText"
  end
end
