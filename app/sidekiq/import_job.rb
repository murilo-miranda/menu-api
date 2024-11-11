class ImportJob
  include Sidekiq::Job
  sidekiq_options queue: 'default'

  def perform(json_data)
    ImportService.new(json_data).execute
  end
end
