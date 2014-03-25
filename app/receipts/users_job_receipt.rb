class UsersJobReceipt
  include ActionView::Helpers::NumberHelper

  def initialize(job)
    @job = job
  end

  def to_pdf
    doc = Prawn::Document.new

    doc.text "Receipt <b>#{@job.title}</b>", inline_format: true
    doc.move_down 50

    heading doc, 'Mechanic details'
    doc.text "#{@job.mechanic.full_name}   #{@job.mechanic.mobile_number}"
    doc.move_down 30

    heading doc, 'Appointment date'
    doc.text @job.scheduled_at.to_s(:date_time)
    doc.move_down 30

    heading doc, 'Location of service'
    doc.text @job.location.full_address
    doc.move_down 50

    breakdown doc

    doc.draw_text "Serviced Signed by:", style: :bold, at: [370, 100]
    doc.rectangle [370, 90], 160, 80
    doc.stroke

    doc.render
  end


  private

  def heading(doc, text)
    doc.text text.upcase
    doc.stroke_horizontal_rule
    doc.move_down 10
  end

  def breakdown(doc)
    jobs_data = [['Jobs', 'Cost']]
    jobs_data += @job.tasks.map do |t|
      [t.title, number_to_currency(t.cost)]
    end
    jobs_data += [['Total', number_to_currency(@job.cost)]]

    last_row = jobs_data.size - 1

    doc.table jobs_data, width: 540, column_widths: [400, 140] do
      cells.borders = []
      cells.padding = 8
      column(1).align = :right
      column(1).borders = [:left]

      row(0).align = :left
      row(0).borders = [:bottom]
      row(0).column(1).borders = [:left, :bottom]

      rows(1..last_row - 1).padding = [10, 8]
      row(last_row).column(0).font_style = :bold
      row(last_row).column(0).align = :right
      row(last_row).borders = [:top]
      row(last_row).column(1).borders = [:left, :top]
    end
  end
end
