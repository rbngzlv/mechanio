class Mechanics::JobsController < Mechanics::ApplicationController
  def show
    # TODO: написать тест, что другой пользователь не может посмотреть мой джоб
    # TODO: может есть еще какието ограничения на выборку или функционал для этой страницы?
    @job = current_mechanic.jobs.find(params[:id])
  end
end
