class Mechanics::PayoutsController < Mechanics::ApplicationController

  def receipt
    payout = current_mechanic.payouts.find(params[:id])
    send_file payout.receipt.path
  end
end
