# == Schema Information
#
# Table name: company_features
#
#  id         :integer          not null, primary key
#  feature_id :integer
#  company_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CompanyFeature < ActiveRecord::Base
  belongs_to :company
  belongs_to :feature

  validates_uniqueness_of :feature_id, scope: :company_id
end
