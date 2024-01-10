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

require 'rails_helper'

RSpec.describe Bank::Account, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
