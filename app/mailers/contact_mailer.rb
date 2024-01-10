class ContactMailer < ApplicationMailer
  def send_contact(contact)
    @contact = contact
    mail(to: 'info@mhr.com', subject: contact.subject, from: contact.email)
  end
end
