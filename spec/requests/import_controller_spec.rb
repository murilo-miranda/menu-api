require 'rails_helper'

describe "Import", type: :request do
  context 'POST /v1/import' do
    context 'with valid JSON data' do
      let(:json_data) { File.read('spec/fixtures/restaurant_data.json') }

      it 'imports restaurants' do
        post '/v1/import', params: {}, headers: { 'Content-Type' => 'application/json', 'RAW_POST_DATA' => json_data }
        expect(Restaurant.count).to eq(2)
      end

      it 'imports menus' do
        post '/v1/import', params: {}, headers: { 'Content-Type' => 'application/json', 'RAW_POST_DATA' => json_data }
        expect(Menu.count).to eq(4)
      end

      it 'imports menu items' do
        post '/v1/import', params: {}, headers: { 'Content-Type' => 'application/json', 'RAW_POST_DATA' => json_data }
        expect(MenuItem.count).to eq(9)
      end

      it 'returns a success response' do
        post '/v1/import', params: {}, headers: { 'Content-Type' => 'application/json', 'RAW_POST_DATA' => json_data }
        expect(response.status).to eq(201)
        expect(response.body).to eq({ message: 'Import successful' }.to_json)
      end
    end

    context 'with invalid JSON data' do
      it 'returns an error response' do
        post '/v1/import', params: {}, headers: { 'Content-Type' => 'application/json', 'RAW_POST_DATA' => 'invalid data' }
        expect(response.status).to eq(422)
        expect(response.body).to eq({ error: 'Invalid JSON data' }.to_json)
      end
    end
  end
end
