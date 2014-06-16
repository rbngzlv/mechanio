require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Job' do
  let!(:mechanic) { create :mechanic }
  let!(:job) { create :job, :with_service, :assigned, mechanic: mechanic }
  let(:id) { job.id }

  get '/api/mechanics/jobs' do

    example_request 'Get a list of upcoming jobs' do
      expect(status).to eq 200
      expect(response_body).to eq [{
        id: job.id,
        title: job.title,
        scheduled_at: job.scheduled_at,
        user: {
          full_name: "John User"
        },
        car: {
          display_title: job.car.display_title
        },
        location: {
          address: "Palm beach 55",
          suburb_name: "Sydney, NSW 2012"
        }
      }].to_json
    end
  end

  get "/api/mechanics/jobs/:id" do

    example_request 'Get job details' do
      expect(status).to eq 200
      expect(response_body).to eq ({
        id: job.id,
        contact_phone: "0410123456",
        discount_amount: nil,
        final_cost: "350.0",
        user: {
          full_name: "John User",
          avatar_thumb: "/assets/fallback/thumb_default.jpg"
        },
        car: {
          display_title: job.car.display_title,
          vin: nil,
          reg_number: nil
        },
        location: {
          address: "Palm beach 55",
          suburb_name: "Sydney, NSW 2012"
        },
        tasks: [{
          id: job.tasks.first.id,
          type: "Service",
          service_plan_id: job.tasks.first.service_plan.id,
          note: "A note to mechanic",
          title: job.tasks.first.title,
          cost: "350.0",
          task_items: [{
            id: job.tasks.first.task_items.first.id,
            itemable_id: job.tasks.first.task_items.first.itemable.id,
            itemable_type: "ServiceCost",
            itemable: {
              id: job.tasks.first.task_items.first.itemable.id,
              description: job.tasks.first.task_items.first.itemable.description,
              cost: "350.0"
            }
          }]
        }]
      }).to_json
    end
  end
end
