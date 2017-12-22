class WebHooksController < ApplicationController
  

   def receive
     if request.headers['Content-Type'] == 'application/json'
       data = JSON.parse(request.body.read)
     else
       # application/x-www-form-urlencoded
       data = params.as_json
     end

     WebHook::Received.save(data: data, integration: params[:integration_name])

     render nothing: true
   end
   
   def view_bookings
     @web_hooks = WebHook.all
   end
   
   def parse_bookings
     WebHook.all.each do |web_hook|
     render json: web_hook.data
     end
   end
 end