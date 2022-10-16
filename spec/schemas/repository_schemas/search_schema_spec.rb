# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RepositorySchemas::SearchSchema do
  let(:params) { { query: 'test' } }

  context 'with valid params' do
    it 'passes validation' do
      schema = described_class.new.call(params)

      expect(schema.errors.to_h).to eq({})
    end
  end

  context 'with invalid params' do
    let(:params) { { query: 'test', page: 'string' } }

    it 'renders error' do
      schema = described_class.new.call(params)
      errors = schema.errors.to_h
      expect(errors[:page]).to include('must be an integer')
    end
  end
end
