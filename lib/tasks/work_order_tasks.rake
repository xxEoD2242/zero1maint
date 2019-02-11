# frozen_string_literal: true

desc 'Check work orders for overdue'
task check_work_orders_overdue: :environment do
  @requests = Request.where('created_at > ? AND status != ?', 2.months.ago, 'Completed')
  @requests.each do |work_order|
    email = User.find_by(name: work_order.creator).email
    if Time.now > work_order.completion_date
      work_order.update(overdue: true, status: 'Overdue')
      UserMailer.overdue_work_order_email(email, work_order)
    end
  end
end

desc 'Deadline vehicles for overdue work orders'
task deadline_vehicles_overdue_work_orders: :environment do
  Vehicle.all.each do |vehicle|
    unless vehicle.requests.where(status: "Overdue").empty?
      vehicle.update(work_orders_overdue: true)
    end
  end
end
