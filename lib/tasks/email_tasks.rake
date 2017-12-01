desc 'send weekly rzr report'
task send_weekly_rzr_report: :environment do
  UserMailer.weekly_rzr_report_email(User.find_by(name: "Rick")).deliver!
  Report.create(title: "Weekly Razor Report For #{Time.now.strftime('%D')}", description: "Overview of all Razors currently In and Out of Service. Contact **** for any questiosn.", report_type: "Weekly-RZR", status: "Created")
end