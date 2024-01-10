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

class Remark < ActiveRecord::Base
  belongs_to :remarkable, polymorphic: true
  belongs_to :remarked_by, :class_name => 'Employee', foreign_key: :remarked_by_id
  validates_presence_of :message
end
