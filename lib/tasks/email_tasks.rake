desc 'send weekly rzr report'
task send_weekly_rzr_report: :environment do
  UserMailer.weekly_rzr_report_email(User.find_by(name: "Rick")).deliver!
  Report.create(title: "Weekly Razor Report For #{(Time.now - 7.days).strftime('%D')} - #{Time.now.strftime('%D')}", description: "Overview of all Razors currently In and Out of Service. Contact **** for any questiosn.", report_type: "Weekly-RZR", status: "Created")
end

desc 'send weekly defect work order report'
task send_weekly_defects_report: :environment do
  UserMailer.weekly_defects_report_email.deliver!
  Report.create(title: "Weekly Defect Work Order Report For #{(Time.now - 7.days).strftime('%D')} - #{Time.now.strftime('%D')}", description: "Overview of all defect work orders created or in-progress. Contact **** for any questiosn.", report_type: "Weekly", status: "Created")
end

desc 'send weekly work order report'
task send_weekly_work_order_report: :environment do
  UserMailer.weekly_work_order_report_email.deliver!
  Report.create(title: "Weekly Work Order Report For #{(Time.now - 7.days).strftime('%D')} - #{Time.now.strftime('%D')}", description: "Overview of all work orders created or in-progress for the previous month. Contact **** for any questiosn.", report_type: "Weekly", status: "Created")
end