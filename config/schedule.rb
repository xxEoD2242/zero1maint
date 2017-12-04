every :monday, :at => '12am' do
  rake 'send_weekly_rzr_report'
  rake 'send_weekly_defects_report'
  rake 'send_weekly_work_order_report'
  rake 'check_work_orders_overdue'
end
