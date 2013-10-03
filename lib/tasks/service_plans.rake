require 'csv'

# This script imports data from service spreadsheet, and creates makes, models, model variations and service plans.
# In future it should instead match with existing models from separate car models spreadsheet.

namespace :import do
  desc "Import service periods"
  task service_plans: :environment do

    intervals = []
    transmissions = %w(Auto Man Automatic Manual)
    body_types = %w(Sedan HatchBack Wagon Coupe Conv. Conve convertible Utility)
    count = 1

    Make.delete_all
    Model.delete_all
    ModelVariation.delete_all
    ServicePlan.delete_all
    BodyType.delete_all

    CSV.foreach('./db/fixedpricecarservice_3108.csv', headers: :first_row) do |r|
      version = r[' Version'].gsub('\u0027', ' ')
      details = r[' Service Inclusions:']

      dummy, from_year, to_year = details.match(/(\d{4})-(\d{4})/).to_a
      transmission = details.match(/\b(Auto|Automatic)\b/) ? 'Automatic' : 'Manual'
      fuel = version.match(/\bDiesel\b/) ? 'Diesel' : 'Petrol'
      fuel = 'Hybrid' if version.match(/\bHybrid\b/)
      body_type_name = details.match(to_rx(body_types))[1] rescue nil
      body_type_name = 'Convertible' if %w(Conv. Conve convertible).include?(body_type_name)
      body_type_name = 'Hatchback' if body_type_name == 'HatchBack'
      body_type_name ||= 'Unknown'
      inclusions = r[' Service Inclusions:']
      instructions = r[' Job Instructions']
      parts = r['Parts']
      notes = r['Service Notes']

      version = version.gsub(to_rx(transmissions), '').gsub(to_rx(body_types), '').gsub('  ', ' ')

      match = r[' Service'].match(/Interval \/ (.+)km \/ (.+)mth/)
      if match
        kms_travelled = match[1].to_i * 1000
        months = match[2].to_i
        title = nil
      else
        kms_travelled = nil
        months = nil
        title = r[' Service']
      end

      make = Make.find_or_create_by(name: r['Make'])
      model = Model.where(name: r[' Model'], make_id: make.id).first_or_create
      body_type = BodyType.find_or_create_by(name: body_type_name)

      model_variation = ModelVariation.where(
        make_id: make.id, model_id: model.id, body_type_id: body_type.id,
        title: version, fuel: fuel, transmission: transmission,
        from_year: from_year, to_year: to_year
      ).first_or_create

      model_variation.comment = details
      model_variation.identifier = version.hash.abs.to_s
      model_variation.save

      cost = BigDecimal.new(r[' Drummoyne Auto Care Price'].match(/[\d\.]+/)[0])

      begin
        service_plan = ServicePlan.where(
          make_id: make.id, model_id: model.id, model_variation_id: model_variation.id,
          kms_travelled: kms_travelled, months: months, title: title, cost: cost,
          inclusions: inclusions, instructions: instructions, parts: parts, notes: notes
        ).first_or_create!
      rescue Exception => e
        # TODO: Find out why some rows are skipped

        puts e
        ap r[' Version']
        ap r[' Service Inclusions:']
        next
      end

      print "."
      count += 1
    end
    print "\n"
  end

  def to_rx(ar)
    Regexp.new('(' + ar.join('|') + ')')
  end
end
