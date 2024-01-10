# == Schema Information
#
# Table name: remarks
#
#  id              :integer          not null, primary key
#  message         :text(65535)
#  remarkable_id   :integer
#  remarkable_type :string(255)
#  is_seen         :boolean          default(FALSE)
#  is_admin        :boolean          default(TRUE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  remarked_by_id  :integer
#

FactoryGirl.define do
  factory :remark do
    message Faker::Lorem.sentences
    is_seen false
    is_admin true
  end
end
