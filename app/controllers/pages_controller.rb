class PagesController < ApplicationController

  def index    
  end

  def getgit
    token = ENV["GITHUB_TOKEN"]
    git_api_url = "https://api.github.com/graphql" 
    user_login = params[:user_input].to_s
    query = <<~GQL
            query {
              user(login: "#{user_login}") {
                name
                repositories(first: 20, ownerAffiliations: OWNER, isFork: false) {
                  nodes {
                    name
                    url
                  }
                  pageInfo {
                  hasNextPage
                  endCursor
                  }
                }
              }
            }
            GQL
      
      connection = Faraday.new(url: git_api_url) do |faraday|
      faraday.headers['Content-Type'] = 'application/json'
      faraday.headers['Authorization'] = "Bearer #{token}"
      faraday.adapter Faraday.default_adapter
      end

      response = connection.post do |req|
        req.body = { query: query }.to_json
      end  

      @result = JSON.parse(response.body)

      end

end