class SubscriptionMailer < ApplicationMailer
  def send_email(subscribe)
    @subscription=subscribe
    mail(to: 'gmarifulislamarif@gmail.com',from: subscribe.email)

  end
end
