desc "Check work orders for overdue"
task check_work_orders_overdue: :environment do
  @set_progress = Tracker.find_by(track: "In-Progress")
  @set_new = Tracker.find_by(track: "New")
  @set_overdue = Tracker.find_by(track: "Overdue")
  @requests = Request.where('created_at > ?', 2.months.ago)
  @overdue = @requests.where(tracker_id: @set_progress.id)
  @overdue_2 = @requests.where(tracker_id: @set_new.id)
  @overdue.each do |work_order|
    email = User.find_by(name: work_order.creator).email
  if Time.now > work_order.completion_date
    work_order.update(overdue: true, tracker_id: @set_overdue.id)
    UserMailer.overdue_work_order(email, work_order)
  end
end
@overdue_2.each do |work_order|
  email = User.find_by(name: work_order.creator).email
  if Time.now > work_order.completion_date
    work_order.update(overdue: true, tracker_id: @set_overdue.id)
    UserMailer.overdue_work_order(email, work_order)
  end
end
end