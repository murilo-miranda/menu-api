namespace :import do
  desc "Run the ImportService with a JSON file"
  task :run, [ :json_file ] => :environment do |task, args|
    json_file = args[:json_file]

    puts "Importing data from #{json_file}..."
    json_data = File.read(json_file)

    begin
      puts "Parsing data..."

      parsed_json = JSON.parse(json_data)

      puts "Executing creations..."
      ImportService.new(parsed_json).execute
      puts "Import successful!"
      puts "You can see a detailed log at #{Rails.root}/log/import.log"
    rescue StandardError => e
      puts "Error importing data: #{e.message}"
    end
  end
end
