# == Schema Information
#
# Table name: employees
#
#  id                          :integer          not null, primary key
#  email                       :string(255)      default(""), not null
#  encrypted_password          :string(255)      default("")
#  reset_password_token        :string(255)
#  reset_password_sent_at      :datetime
#  remember_created_at         :datetime
#  sign_in_count               :integer          default(0), not null
#  current_sign_in_at          :datetime
#  last_sign_in_at             :datetime
#  current_sign_in_ip          :string(255)
#  last_sign_in_ip             :string(255)
#  confirmation_token          :string(255)
#  confirmed_at                :datetime
#  confirmation_sent_at        :datetime
#  unconfirmed_email           :string(255)
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  first_name                  :string(255)
#  last_name                   :string(255)
#  note                        :text(65535)
#  location                    :string(255)
#  dob                         :date
#  address                     :text(65535)
#  gender                      :string(255)
#  image                       :string(255)
#  department_id               :integer
#  role                        :string(255)      default("staff")
#  invitation_token            :string(255)
#  invitation_created_at       :datetime
#  invitation_sent_at          :datetime
#  invitation_accepted_at      :datetime
#  invitation_limit            :integer
#  invited_by_id               :integer
#  invited_by_type             :string(255)
#  blood_group                 :string(255)
#  joining_date                :date
#  designation_id              :integer
#  basic_salary                :float(24)
#  mobile                      :string(255)
#  nid                         :string(255)
#  kin_name                    :string(255)
#  kin_contact                 :string(255)
#  is_active                   :boolean          default(TRUE)
#  deactivated_by              :integer
#  deactivate_date             :date
#  id_card_no                  :string(255)
#  employee_type               :string(255)
#  present_address             :string(255)
#  permanent_address           :string(255)
#  color                       :string(255)
#  slug                        :string(255)
#  kin_relationship            :string(255)
#  marital_status              :string(255)
#  nationality                 :string(255)
#  country                     :string(255)
#  attachment                  :string(255)
#  bank_account_number         :string(255)
#  bank_details                :text(65535)
#  previous_employment_history :string(255)
#  religion                    :string(255)
#

require 'faker'

FactoryGirl.define do
  factory :employee do |f|
    f.sequence(:email) { |n| "test#{n}@auth_forum.com" }
    password 'password'
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    location Faker::Address.secondary_address
    present_address Faker::Address.secondary_address
    permanent_address Faker::Address.secondary_address
    deactivate_date Faker::Date.between(2.days.ago, Date.today)
    role Employee::ROLE[:stuff]
  end
end
