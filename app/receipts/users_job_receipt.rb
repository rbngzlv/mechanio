class UsersJobReceipt
  include ActionView::Helpers::NumberHelper
  include JobHelper

  def initialize(job)
    @job = job
    @doc = Prawn::Document.new
  end

  def to_pdf
    @doc.image Rails.root.join('app/assets/images/mechanio_logo.png'), at: [0, @doc.cursor], width: 185

    top = @doc.bounds.top - 60

    @doc.bounding_box [0, top], width: 210 do
      summary
    end

    @doc.bounding_box [220, top + 50], width: 340 do
      @doc.formatted_text [text: "RECEIPT", size: 20]
      @doc.move_down 27

      @doc.text "JOB ID: #{@job.uid}"
      @doc.move_down 2

      @doc.text "RECEIPT ISSUED ON: #{@job.completed_at.to_s(:date)}"
      @doc.move_down 43

      breakdown
    end

    @doc.render
  end


  private

  def summary
    @doc.text "ABN: 43 154 895 977"
    @doc.move_down 2
    @doc.formatted_text [text: "www.mechanio.com", link: "http://www.mechanio.com", color: '2222ff']
    @doc.move_down 2
    @doc.text "Phone: 1300 766 781"
    @doc.move_down 2
    @doc.text 'Email: <a href="mailto:support@mechanio.com">support@mechanio.com</a>', inline_format: true
    @doc.move_down 20

    @doc.text "BILLED TO"
    @doc.move_down 2
    @doc.text @job.user.full_name
    @doc.move_down 20

    @doc.text "APPOINTMENT TIME & DATE"
    @doc.move_down 2
    @doc.text "#{@job.event.time_range} #{@job.scheduled_at.to_s(:date_short)}"
    @doc.move_down 20

    @doc.text "LOCATION"
    @doc.move_down 2
    @doc.text @job.location.full_address
    @doc.move_down 20

    @doc.text "CAR"
    @doc.move_down 2
    @doc.text @job.car.display_title
    @doc.move_down 20

    @doc.text "SERVICED BY"
    @doc.move_down 2
    @doc.text @job.mechanic.full_name
    @doc.move_down 30

    @doc.text "PAYMENT"
    @doc.move_down 2
    @doc.text "#{@job.credit_card.card_type} - #{@job.credit_card.last_4}"
    @doc.move_down 30

    @doc.text "AMOUNT CHARGED"
    @doc.move_down 2
    @doc.formatted_text [text: formatted_cost(@job.final_cost), size: 20]
    @doc.move_down 30

    @doc.text "<i>Thank you for business!</i>", inline_format: true
  end

  def breakdown
    jobs_data = []

    column_widths = [240, 80]

    @job.tasks.each do |t|

      breakdown_table [t.title, formatted_cost(t.cost)]

      t.task_items.each do |i|
        row = i.itemable.data
        row[2] = formatted_cost(row[2])
        row.slice!(1)

        breakdown_table row
      end

      @doc.move_down 10
    end

    breakdown_table ["Charge subtotal", formatted_cost(@job.cost)]
    @doc.move_down 10

    if @job.discount
      breakdown_table ["Discount #{@job.discount.code}", formatted_cost(-@job.discount_amount)]
      @doc.move_down 10
    end

    breakdown_table ["Total including GST (10%)", formatted_cost(@job.final_cost)]
    @doc.move_down 10

    breakdown_table ["Total charged", formatted_cost(-@job.final_cost)], bold: true
    breakdown_table ["Outstanding balance", number_to_currency(0)]
  end

  def breakdown_table(data, options = {})
    @doc.table [data], width: 320, column_widths: [240, 80] do
      cells.borders = []
      cells.padding = 2
      column(1).align = :right
      cells.font_style = :bold if options[:bold]
    end
  end
end
