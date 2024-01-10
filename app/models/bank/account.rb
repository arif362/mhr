# == Schema Information
#
# Table name: bank_accounts
#
#  id            :integer          not null, primary key
#  department_id :integer
#  name          :string(255)
#  number        :string(255)
#  bank_name     :string(255)
#  bank_branch   :string(255)
#  balance       :float(24)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Bank::Account < ActiveRecord::Base
  belongs_to :department
  validates_presence_of :name, :number, :bank_name, :bank_branch, :balance
end
