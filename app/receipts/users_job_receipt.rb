class UsersJobReceipt
  include ActionView::Helpers::NumberHelper
  include JobHelper

  def initialize(job)
    @job = job
  end

  def to_pdf
    doc = Prawn::Document.new

    doc.image Rails.root.join('app/assets/images/mechanio_logo.png'), at: [0, 720], width: 185
    doc.move_down 60

    doc.text "Receipt <b>Detail for #{@job.car.display_title} in #{@job.scheduled_at.year}</b>", inline_format: true
    doc.move_down 40

    heading doc, 'Mechanic details'
    doc.text "#{@job.mechanic.full_name}         #{@job.mechanic.mobile_number}         #{@job.mechanic.location.full_address}"
    doc.move_down 30

    heading doc, 'Appointment date'
    date = @job.scheduled_at.to_s(:date)
    time = @job.event.time_range
    doc.text "#{date}                            #{time}"
    doc.move_down 30

    heading doc, 'Location of service'
    doc.text @job.location.full_address
    doc.move_down 50

    breakdown doc

    # doc.draw_text "Serviced Signed by:", style: :bold, at: [370, 100]
    # doc.rectangle [370, 90], 160, 80
    # doc.stroke

    doc.render
  end


  private

  def heading(doc, text)
    doc.text text.upcase
    doc.stroke_horizontal_rule
    doc.move_down 10
  end

  def breakdown(doc)
    jobs_data = []

    column_widths = [350, 80, 110]

    doc.table [['Jobs', 'Qty/Hours', 'Cost']], width: 540, column_widths: column_widths do
      column(2).borders = [:left]
      column(2).align = :right
      row(0).borders = [:bottom]
      row(0).column(2).borders = [:left, :bottom]
    end

    @job.tasks.each do |t|

      doc.table [[t.title, '', formatted_cost(t.cost)]], width: 540, column_widths: column_widths do
        cells.font_style = :bold
        cells.borders = []
        column(2).borders = [:left]
        column(2).align = :right
      end

      t.task_items.each do |i|
        next if i.itemable_type == 'ServiceCost'

        row = i.itemable.data
        row[2] = formatted_cost(row[2])

        doc.table [row], width: 540, column_widths: column_widths do
          cells.size = 10
          cells.borders = []
          column(0).padding_left = 15
          column(2).borders = [:left]
          column(2).align = :right
        end
      end
    end

    cost = formatted_cost(@job.cost)
    doc.table [['', 'Total', "#{cost} + GST"]], width: 540, column_widths: column_widths do
      cells.font_style = :bold
      row(0).borders = [:top]
      row(0).column(2).borders = [:left, :top]
      column(2).align = :right
    end
  end
end
