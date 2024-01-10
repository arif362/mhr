class BillingController < ApplicationController
  def dashboard
    def index
      @current_company_id = current_department.id
      @currency = '$' #currency_is_off? ? "" : params[:currency].present? ? Currency.find_by_id(params[:currency]) : Currency.default_currency
      gon.currency_code = '$' #@currency_code = @currency.present? ? @currency.code : '$'
      gon.currency_id = @currency.present? ? @currency.id : ""
      gon.chart_data = [] #Reporting::Dashboard.get_chart_data(@currency, @current_company_id)
      @recent_activity = [] #Reporting::Dashboard.get_recent_activity(@currency, @current_company_id)
      @aged_invoices = [] #Reporting::Dashboard.get_aging_data(@currency, @current_company_id)
      #@outstanding_invoices = (@aged_invoices.attributes["zero_to_thirty"] || 0) +
      #    (@aged_invoices.attributes["thirty_one_to_sixty"] || 0) +
      #    (@aged_invoices.attributes["sixty_one_to_ninety"] || 0) +
      #    (@aged_invoices.attributes["ninety_one_and_above"] || 0)
      @current_invoices = Billing::Invoice.current_invoices(@current_company_id)
      @past_invoices = Billing::Invoice.past_invoices(@current_company_id)
      @amount_billed = Billing::Invoice.total_invoices_amount(@currency, @current_company_id)
      @outstanding_invoices = [] #Reporting::Dashboard.get_outstanding_invoices(@currency, @current_company_id)
      @ytd_income = [] #Reporting::Dashboard.get_ytd_income(@currency, @current_company_id)
      @unit_size='medium-unit'
    end
  end
end