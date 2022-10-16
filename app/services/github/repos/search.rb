# frozen_string_literal: true

# It searches public github repositories and returns results as per match criteria
# It takes params like :q for query string
# :sort => The sort field. One of stars, forks, or updated
# :order => The sort order if sort parameter is provided.
# https://github.com/piotrmurach/github/blob/master/lib/github_api/client/search.rb#L72
# By default it returns 30 results per page and max total count of 1000
# https://docs.github.com/en/rest/search#search-repositories
# Currently implement authenticated way so it serves 10 requests per minute. For more information
# https://docs.github.com/en/rest/search#rate-limit
module Github
  module Repos
    class Search
      PER_PAGE = 30
      MAX_COUNT = 1000

      class << self
        def call(params = {})
          return {} unless params[:q]

          fetch_repositories(params)
        end

        private

        def fetch_repositories(params)
          repositories = Github::Client::Search.new.repos(params)

          repos = repositories.items.map { |repo| Repository.new(repo) }

          { repos:, total_count: total_repo_count(repositories.total_count) }
        end

        def total_repo_count(count)
          count <= MAX_COUNT ? count : MAX_COUNT
        end
      end
    end
  end
end
