every :monday, :at => '12am' do
  rake 'send_weekly_rzr_report'
  rake 'send_weekly_defects_report'
end
