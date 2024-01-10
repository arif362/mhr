# == Schema Information
#
# Table name: billing_invoice_line_items
#
#  id               :integer          not null, primary key
#  invoice_id       :integer
#  item_id          :integer
#  item_name        :string(255)
#  item_description :string(255)
#  item_unit_cost   :decimal(10, 2)
#  item_quantity    :decimal(10, 2)
#  tax_1            :integer
#  tax_2            :integer
#  archive_number   :string(255)
#  archived_at      :datetime
#  deleted_at       :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  actual_price     :decimal(10, 2)   default(0.0)
#  estimate_id      :integer
#

#
# Open Source Billing - A super simple software to create & send invoices to your customers and
# collect payments.
# Copyright (C) 2013 Mark Mian <mark.mian@opensourcebilling.org>
#
# This file is part of Open Source Billing.
#
# Open Source Billing is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Open Source Billing is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Open Source Billing.  If not, see <http://www.gnu.org/licenses/>.
#
module Billing
  class InvoiceLineItem < ActiveRecord::Base
    # associations
    belongs_to :invoice
    belongs_to :estimate
    belongs_to :item
    belongs_to :tax1, :foreign_key => 'tax_1', :class_name => 'Tax'
    belongs_to :tax2, :foreign_key => 'tax_2', :class_name => 'Tax'

    # archive and delete
    acts_as_archival
    acts_as_paranoid

    attr_accessor :tax_one, :tax_two

    def unscoped_item
      Item.unscoped.find_by_id self.item_id
    end
  end
end
