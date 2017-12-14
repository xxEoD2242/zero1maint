every :monday, :at => '12am' do
  rake 'check_work_orders_overdue'
  rake 'send_weekly_rzr_report'
  rake 'send_weekly_defects_report'
  rake 'send_weekly_work_order_report'
  rake 'send_weekly_new_progress_report'
  rake 'send_weekly_checklist_report'
end
