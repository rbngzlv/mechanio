module JobHelper

  def job_breakdown(job)
    tasks = job.tasks.map do |t|
      task = { title: t.title, value: formatted_cost(t.cost) }
      if t.type == 'Service'
        [task, { title: "Parts included: #{t.service_plan.parts}", value: '' }]
      else
        task
      end
    end
    tasks.flatten
  end

  def job_totals(job)
    totals = []
    totals << { title: "#{job.discount.title} discount", value: formatted_cost(job.discount_amount) } if job.discount
    totals << { title: 'Total Fees', value: formatted_cost(job.final_cost) }
  end

  def formatted_cost(amount)
    return 'pending' if amount.nil?
    return 'included' if amount.zero?
    number_to_currency(amount)
  end

  def requested_by(job)
    job.client_name + ' on ' + job.created_at.to_s(:date_time_short)
  end

  def allocated_to(job)
    if @job.mechanic && @job.scheduled_at
      @job.mechanic.full_name + ' on ' + job.scheduled_at.to_s(:date_time_short)
    else
      'Unassigned'
    end
  end

  def job_statuses
    labels = Job::STATUSES.map { |s| I18n.t(s, scope: 'activerecord.attributes.job.status') }
    labels.zip(Job::STATUSES)
  end

  def job_status(status)
    css = case status
      when 'pending'    then 'warning'
      when 'estimated'  then 'info'
      when 'assigned'   then 'primary'
      when 'completed'  then 'completed'
      when 'cancelled'  then 'default'
      when 'rated'      then 'default'
      when 'charged'    then 'default'
      when 'paid_out'   then 'success'
      when 'charge_failed'     then 'danger'
      when 'estimate_deleted'  then 'danger'
    end

    content_tag :span, status.humanize, class: "label label-#{css}"
  end
end
