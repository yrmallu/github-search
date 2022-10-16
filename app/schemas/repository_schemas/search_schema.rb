# frozen_string_literal: true

module RepositorySchemas
  class SearchSchema < Dry::Validation::Contract
    params do
      optional(:query)
      optional(:page).filled(:integer)
    end
  end
end
