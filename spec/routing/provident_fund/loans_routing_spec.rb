# == Schema Information
#
# Table name: provident_fund_loans
#
#  id            :integer          not null, primary key
#  pf_account_id :integer
#  department_id :integer
#  amount        :float(24)
#  description   :text(65535)
#  return_policy :string(255)
#  installment   :integer
#  return_date   :date
#  date          :date
#  is_closed     :boolean          default(FALSE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require "rails_helper"

RSpec.describe ProvidentFund::LoansController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/provident_fund/loans").to route_to("provident_fund/loans#index")
    end

    it "routes to #new" do
      expect(:get => "/provident_fund/loans/new").to route_to("provident_fund/loans#new")
    end

    it "routes to #show" do
      expect(:get => "/provident_fund/loans/1").to route_to("provident_fund/loans#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/provident_fund/loans/1/edit").to route_to("provident_fund/loans#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/provident_fund/loans").to route_to("provident_fund/loans#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/provident_fund/loans/1").to route_to("provident_fund/loans#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/provident_fund/loans/1").to route_to("provident_fund/loans#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/provident_fund/loans/1").to route_to("provident_fund/loans#destroy", :id => "1")
    end

  end
end
