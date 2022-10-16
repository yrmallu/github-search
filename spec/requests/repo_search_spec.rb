# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe 'GET /', type: :request do
  let(:path) { root_url }

  let(:params) { { query: 'tetris' } }
  let(:body)   { JSON.parse(fixture('search/repos.json').read) }
  let(:repos) { github_client_response.items.map { |repo| Repository.new(repo) } }
  let(:github_client) { instance_double(Github::Client::Search) }
  let(:github_client_response) do
    instance_double(Struct.new(:items, :total_count), items: body['items'], total_count: body['total_count'])
  end

  let(:service_response) { { repos:, total_count: body['total_count'] } }

  before do
    allow(Github::Client::Search).to receive(:new).and_return(github_client)
    allow(github_client).to receive(:repos)
      .and_return(github_client_response, status: 200, headers: { content_type: 'application/json; charset=utf-8' })
    allow(Github::Repos::Search).to receive(:call).and_return(service_response)
  end

  context 'with valid params' do
    it 'renders a successful response' do
      get path, params: params
      expect(response.status).to be(200)
    end

    it 'calls the github repos search service' do
      get path, params: params
      expect(Github::Repos::Search).to have_received(:call).with({ page: 1, q: 'tetris' })
    end
  end

  context 'with invalid params' do
    let(:params) { { query: 'tetris', page: '2q' } }

    it 'should respond with 302' do
      get path, params: params
      expect(response.status).to be(302)
    end

    it 'redirects to root path' do
      get path, params: params
      expect(response).to redirect_to root_path
    end

    it 'shows notice message' do
      get path, params: params
      expect(flash[:notice]).to eq('Something went wrong. Please enter valid input.')
    end
  end
end
# rubocop:enable Metrics/BlockLength
