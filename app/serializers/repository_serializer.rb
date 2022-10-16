# frozen_string_literal: true

class RepositorySerializer
  include JSONAPI::Serializer

  attributes :name, :full_name, :html_url
end
