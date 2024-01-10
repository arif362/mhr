# == Schema Information
#
# Table name: billing_payment_terms
#
#  id             :integer          not null, primary key
#  number_of_days :integer
#  description    :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
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
  class PaymentTerm < ActiveRecord::Base
    # associations
    has_many :invoices
    has_many :recurring_profiles
  end
end
