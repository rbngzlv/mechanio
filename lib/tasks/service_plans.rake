require 'csv'

# This script imports data from service spreadsheet, and creates makes, models, model variations and service plans.
# In future it should instead match with existing models from separate car models spreadsheet.

namespace :import do
  desc "Import service periods"
  task service_plans: :environment do

    intervals = []
    transmissions_rx = to_rx %w(Auto Man Automatic Manual)
    body_type_rx = to_rx %w(Sedan HatchBack Wagon Coupe Conv. Conve convertible Utility)
    count = 1

    makes = {}
    models = {}
    model_variations = {}
    body_types = {}

    make_exclude = %(BMW)
    model_exclude = %(GT)

    [Make, Model, ModelVariation, ServicePlan, BodyType].each do |klass|
      klass.delete_all
      klass.connection.execute("ALTER SEQUENCE #{klass.table_name}_id_seq RESTART WITH 1")
    end

    count = errors = 0

    CSV.foreach('./db/service_plans.csv', headers: :first_row) do |r|
      count += 1

      make_name = r['Make'].to_s
      make_name = make_name.titleize unless make_exclude.include?(make_name)
      model_name = r[' Model'].to_s
      model_name = model_name.titleize unless model_exclude.include?(model_name)

      version = r[' Version'].to_s.gsub('\u0027', ' ')
      details = r[' Service Inclusions:'].to_s

      dummy, from_year, to_year = details.match(/(\d{4})-(\d{4})/).to_a
      transmission = details.match(/\b(Auto|Automatic)\b/) ? 'Automatic' : 'Manual'
      fuel = version.match(/\bDiesel\b/) ? 'Diesel' : 'Petrol'
      fuel = 'Hybrid' if version.match(/\bHybrid\b/)
      body_type_name = details.match(body_type_rx)[1] rescue nil
      body_type_name = 'Convertible' if %w(Conv. Conve convertible).include?(body_type_name)
      body_type_name = 'Hatchback' if body_type_name == 'HatchBack'
      body_type_name ||= 'Unknown'
      inclusions = r[' Service Inclusions:'].to_s
      instructions = r[' Job Instructions'].to_s
      parts = r['Parts'].to_s
      notes = r['Service Notes'].to_s

      version = version.gsub(transmissions_rx, '').gsub(body_type_rx, '').gsub('  ', ' ')
      variation_uid = [make_name, model_name, version, from_year, to_year, body_type_name, transmission, fuel].join('||').hash.abs.to_s

      match = r[' Service'].to_s.match(/Interval \/ (.+)km \/ (.+)mth/)
      if match
        kms_travelled = match[1].to_i * 1000
        months = match[2].to_i
        title = nil
      else
        kms_travelled = nil
        months = nil
        title = r[' Service'].to_s
      end

      unless make = makes[make_name]
        make = makes[make_name] = Make.create(name: make_name)
        models[make.name] = {}
        puts "\n"
        puts '-------------------'
        puts make_name
        puts "\n"
      end

      unless model = models[make_name][model_name]
        model = models[make_name][model_name] = Model.create(name: model_name, make_id: make.id)
        puts "\n"
        puts model_name
      end

      unless body_type = body_types[body_type_name]
        body_type = body_types[body_type_name] = BodyType.create(name: body_type_name)
      end

      unless model_variation = model_variations[variation_uid]
        model_variation = model_variations[variation_uid] = ModelVariation.create(
          make_id: make.id, model_id: model.id, body_type_id: body_type.id,
          title: version, fuel: fuel, transmission: transmission,
          from_year: from_year, to_year: to_year, comment: details, identifier: variation_uid
        )
      end

      cost = r[' Drummoyne Auto Care Price'].to_s.match(/[\d\.]+/)
      cost = BigDecimal.new(cost[0]) if cost

      begin
        service_plan = ServicePlan.where(
          make_id: make.id, model_id: model.id, model_variation_id: model_variation.id,
          kms_travelled: kms_travelled, months: months, title: title, cost: cost,
          inclusions: inclusions, instructions: instructions, parts: parts, notes: notes
        ).first_or_create!
      rescue Exception => e
        # TODO: Find out why some rows are skipped
        print "x"
        errors += 1
        # ap "Line #{count}"
        # ap "#{make_name} #{model_name} #{version}"
        # ap variation_uid
        next
      end

      # print "\n"
      print "."
      count += 1
    end
    puts "Total: #{count}"
    puts "Errors: #{errors}"
  end

  def to_rx(ar)
    Regexp.new('(' + ar.join('|') + ')')
  end
end
