# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Github::Repos::Search do
  describe '.call' do
    subject(:operation) { -> { described_class.call(params) } }
    subject(:result) { operation.call }

    let(:params) { { q: 'tetris' } }
    let(:body)   { JSON.parse(fixture('search/repos.json').read) }
    let(:github_client) { instance_double(Github::Client::Search) }
    let(:response) do
      instance_double(Struct.new(:items, :total_count), items: body['items'], total_count: body['total_count'])
    end

    before do
      allow(Github::Client::Search).to receive(:new).and_return(github_client)
      allow(github_client).to receive(:repos)
        .and_return(response, status: 200, headers: { content_type: 'application/json; charset=utf-8' })
    end

    it 'calls the Github Search service' do
      operation.call

      expect(github_client).to have_received(:repos).with(params)
    end

    it 'should get information' do
      expect(result[:total_count]).to eq body['total_count']
    end
  end
end
