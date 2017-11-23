class UserMailer < ApplicationMailer
  default from: 'tts110117@gmail.com'
  
  
  def new_request_email(user, request)
    @request = request
    mail(to: user.email, subject: "Defect Work Order has been created!" )
  end 
end
