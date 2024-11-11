class V1::ImportController < ApplicationController
  def create
    json_data = JSON.parse(request.body.read)

    ImportJob.perform_async(json_data)

    render json: { message: "Import successful, data will be processed in background" }, status: :created
  rescue JSON::ParserError => e
    render json: { error: "Invalid JSON data" }, status: :unprocessable_entity
  end
end
