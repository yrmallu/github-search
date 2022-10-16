# frozen_string_literal: true

require 'will_paginate/array'

class RepositoriesController < ApplicationController
  before_action :validate

  # Actually written this endpoint to render API response in json format but
  # modified to support html
  def index
    repos = Github::Repos::Search.call({ q: params[:query], page: (params[:page] || 1) })
    @pages = (1..(repos[:total_count] || 1)).to_a.paginate(page: params[:page],
                                                           per_page: Github::Repos::Search::PER_PAGE)
    @repositories = RepositorySerializer.new(repos[:repos]).serializable_hash
  end

  private

  def validate
    blind_date_schema = RepositorySchemas::SearchSchema.new.call(params.permit!.to_h)

    return unless blind_date_schema.errors.to_h.present?

    redirect_to root_path, notice: 'Something went wrong. Please enter valid input.'
  end
end
