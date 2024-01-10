# == Schema Information
#
# Table name: billing_client_contacts
#
#  id            :integer          not null, primary key
#  client_id     :integer
#  first_name    :string(255)
#  last_name     :string(255)
#  email         :string(255)
#  home_phone    :string(255)
#  mobile_number :string(255)
#  deleted_at    :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
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
  class ClientContact < ActiveRecord::Base
    # associations
    belongs_to :client

    # archive and delete
    # acts_as_archival
    # acts_as_paranoid
  end
end
