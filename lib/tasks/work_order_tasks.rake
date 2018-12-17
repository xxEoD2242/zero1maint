# frozen_string_literal: true

desc 'Check work orders for overdue'
task check_work_orders_overdue: :environment do
  @requests = Request.where('created_at > ?', 2.months.ago)
  @overdue = @requests.is_in_progress
  @overdue_2 = @requests.is_overdue
  @overdue.each do |work_order|
    email = User.find_by(name: work_order.creator).email
    if Time.now > work_order.completion_date
      work_order.update(overdue: true, status: 'Overdue')
      UserMailer.overdue_work_order_email(email, work_order)
    end
  end
  @overdue_2.each do |work_order|
    email = User.find_by(name: work_order.creator).email
    if Time.now > work_order.completion_date
      work_order.update(overdue: true, status: 'Overdue')
      UserMailer.overdue_work_order_email(email, work_order)
    end
  end
end
