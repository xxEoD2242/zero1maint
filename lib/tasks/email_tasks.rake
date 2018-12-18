# frozen_string_literal: true

desc 'send weekly rzr report'
task send_weekly_rzr_report: :environment do
  if Date.today.monday?
    UserMailer.weekly_rzr_report_email.deliver!
    Report.create(title: "Weekly Razor Report For #{(Time.now - 7.days).strftime('%D')} - #{Time.now.strftime('%D')}",
                  description: 'Overview of all Razors currently In and Out of Service. Contact Ryan for any questiosn.',
                  report_type: 'Weekly-RZR', status: 'Created')
  end
end

desc 'send weekly tour car report'
task send_weekly_tour_car_report: :environment do
  if Date.today.monday?
    UserMailer.weekly_tour_car_report.deliver!
    Report.create(title: "Weekly Tour Car Report For #{(Time.now - 7.days).strftime('%D')} - #{Time.now.strftime('%D')}",
                  description: 'Overview of all Razors currently In and Out of Service. Contact Ryan for any questiosn.',
                  report_type: 'Weekly-RZR', status: 'Created')
  end
end

desc 'send weekly other vehicles report'
task send_weekly_other_vehicles_report: :environment do
  if Date.today.monday?
    UserMailer.weekly_other_vehicles_report.deliver!
    Report.create(title: "Weekly Other Vehicles Report For #{(Time.now - 7.days).strftime('%D')} - #{Time.now.strftime('%D')}",
                  description: 'Overview of all Razors currently In and Out of Service. Contact Ryan for any questiosn.',
                  report_type: 'Weekly-RZR', status: 'Created')
  end
end

desc 'send weekly defect work order report'
task send_weekly_defects_report: :environment do
  if Date.today.monday?
    UserMailer.weekly_defects_report_email.deliver!
    Report.create(title: "Weekly Defect Work Order Report For #{(Time.now - 7.days).strftime('%D')} - #{Time.now.strftime('%D')}",
                  description: 'Overview of all defect work orders created or in-progress. Contact Ryan for any questiosn.',
                  report_type: 'Weekly-Defect', status: 'Created')
  end
end

desc 'send weekly repairs work order report'
task send_weekly_repairs_report: :environment do
  if Date.today.monday?
    UserMailer.weekly_repairs_report.deliver!
    Report.create(title: "Weekly Repair Work Order Report For #{(Time.now - 7.days).strftime('%D')} - #{Time.now.strftime('%D')}",
                  description: 'Overview of all defect work orders created or in-progress. Contact **** for any questiosn.',
                  report_type: 'Weekly-Defect', status: 'Created')
  end
end

desc 'send weekly work order report'
task send_weekly_work_order_report: :environment do
  if Date.today.monday?
    UserMailer.weekly_work_order_report_email.deliver!
    Report.create(title: "Weekly Work Order Report For #{(Time.now - 7.days).strftime('%D')} - #{Time.now.strftime('%D')}",
                  description: 'Overview of all work orders created or in-progress for the previous month. Contact **** for any questiosn.',
                  report_type: 'Weekly', status: 'Created')
  end
end

desc 'send weekly checklist report'
task send_weekly_checklist_report: :environment do
  if Date.today.monday?
    UserMailer.weekly_event_checklists_email.deliver!
    Report.create(title: "Weekly Events Checklist Report For #{(Time.now - 7.days).strftime('%D')} - #{Time.now.strftime('%D')}",
                  description: 'Overview of all defect work orders created or in-progress. Contact **** for any questiosn.',
                  report_type: 'Weekly-Checklist', status: 'Created')
  end
end

desc 'send weekly defects reported'
task send_weekly_defects_reported: :environment do
  if Date.today.monday?
    UserMailer.weekly_defects_reported.deliver!
  end
end

desc 'send weekly defects outstanding'
task send_weekly_defects_outstanding: :environment do
  if Date.today.monday?
    UserMailer.weekly_defects_outstanding.deliver!
  end
end
