desc 'send weekly rzr report'
task send_weekly_rzr_report: :environment do
  UserMailer.weekly_rzr_report_email(User.find_by(name: "Me")).deliver!
end