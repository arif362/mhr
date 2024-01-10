# == Schema Information
#
# Table name: provident_fund_loan_returns
#
#  id            :integer          not null, primary key
#  date          :date
#  amount        :float(24)
#  department_id :integer
#  loan_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require "rails_helper"

RSpec.describe ProvidentFund::LoanReturnsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/provident_fund/loan_returns").to route_to("provident_fund/loan_returns#index")
    end

    it "routes to #new" do
      expect(:get => "/provident_fund/loan_returns/new").to route_to("provident_fund/loan_returns#new")
    end

    it "routes to #show" do
      expect(:get => "/provident_fund/loan_returns/1").to route_to("provident_fund/loan_returns#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/provident_fund/loan_returns/1/edit").to route_to("provident_fund/loan_returns#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/provident_fund/loan_returns").to route_to("provident_fund/loan_returns#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/provident_fund/loan_returns/1").to route_to("provident_fund/loan_returns#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/provident_fund/loan_returns/1").to route_to("provident_fund/loan_returns#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/provident_fund/loan_returns/1").to route_to("provident_fund/loan_returns#destroy", :id => "1")
    end

  end
end
