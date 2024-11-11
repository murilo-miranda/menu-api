require 'rails_helper'

describe ImportJob, type: :job do
  before(:all) do
    Sidekiq::Testing.fake!
  end
  
  let(:json_data) { File.read('spec/fixtures/restaurant_data.json') }
  
  it "job in correct queue" do 
    expect { ImportJob.perform_async(JSON.parse(json_data)) }.to enqueue_sidekiq_job.on("default")
  end
end
