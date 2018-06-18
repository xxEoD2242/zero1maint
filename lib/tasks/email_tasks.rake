# frozen_string_literal: true

desc 'send weekly rzr report'
task send_weekly_rzr_report: :environment do
  UserMailer.weekly_rzr_report_email.deliver!
  Report.create(title: "Weekly Razor Report For #{(Time.now - 7.days).strftime('%D')} - #{Time.now.strftime('%D')}", description: 'Overview of all Razors currently In and Out of Service. Contact **** for any questiosn.', report_type: 'Weekly-RZR', status: 'Created')
end

desc 'send weekly defect work order report'
task send_weekly_defects_report: :environment do
  UserMailer.weekly_defects_report_email.deliver!
  Report.create(title: "Weekly Defect Work Order Report For #{(Time.now - 7.days).strftime('%D')} - #{Time.now.strftime('%D')}", description: 'Overview of all defect work orders created or in-progress. Contact **** for any questiosn.', report_type: 'Weekly-Defect', status: 'Created')
end

desc 'send weekly new & in-progress work order report'
task send_weekly_new_progress_report: :environment do
  UserMailer.weekly_new_progress_report_email.deliver!
  Report.create(title: "Weekly New & In-Progress Work Orders Report For #{(Time.now - 7.days).strftime('%D')} - #{Time.now.strftime('%D')}", description: 'Overview of all New & In-Progress work orders created or in-progress. Contact **** for any questiosn.', report_type: 'Weekly-New/In-Progress', status: 'Created')
end

desc 'send weekly work order report'
task send_weekly_work_order_report: :environment do
  UserMailer.weekly_work_order_report_email.deliver!
  Report.create(title: "Weekly Work Order Report For #{(Time.now - 7.days).strftime('%D')} - #{Time.now.strftime('%D')}", description: 'Overview of all work orders created or in-progress for the previous month. Contact **** for any questiosn.', report_type: 'Weekly', status: 'Created')
end

desc 'send weekly checklist report'
task send_weekly_checklist_report: :environment do
  UserMailer.weekly_event_checklists_email.deliver!
  Report.create(title: "Weekly Events Checklist Report For #{(Time.now - 7.days).strftime('%D')} - #{Time.now.strftime('%D')}", description: 'Overview of all defect work orders created or in-progress. Contact **** for any questiosn.', report_type: 'Weekly-Checklist', status: 'Created')
end

desc 'send daily events report'
task send_daily_events_report: :environment do
  UserMailer.daily_events_report_email.deliver!
end
