class V1::ImportController < ApplicationController
  def create
    begin
      json_data = JSON.parse(request.body.read)

      ImportService.new(json_data).execute

      render json: { message: 'Import successful' }, status: :created
    rescue JSON::ParserError => e
      render json: { error: 'Invalid JSON data' }, status: :unprocessable_entity
    rescue StandardError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end
end