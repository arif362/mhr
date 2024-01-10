class InvoiceMailer < ApplicationMailer

  def new_invoice_email(client, invoice, id, current_employee)
    @client = client
    @invoice = invoice
    @invoice_id = id
    @present_user = current_employee
    mail(to: @client.email, subject: 'A new invoice from Mihisoft.', from: @present_user.email)
  end

end
