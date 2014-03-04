module AdminHelper

  def prepare_job_edit
    @service_plans = @job.car.service_plans
    @service_plans_json = @service_plans.as_json(only: [:id, :cost, :display_title])
    @payout ||= @job.payout || @job.build_payout
  end

  def job_form(job, angular_data, &block)
    ng_init = angular_data.to_json

    simple_form_for [:admins, job], html: { 'ng-controller' => 'JobsController', 'ng-init' => "init(#{ng_init})" } do |f|
      yield(f)
    end
  end
end
