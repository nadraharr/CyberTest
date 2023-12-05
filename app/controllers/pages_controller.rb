class PagesController < ApplicationController

  def index    
  end

  def getgit(next_page_option = nil, prev_page_option = nil, first_option = "first: 20", last_option = nil)    
    
    token = ENV["GITHUB_TOKEN"]
    git_api_url = "https://api.github.com/graphql"    
    user_login = params[:user_login] || params[:user_input].to_s.strip    
    query = <<~GQL
            query {
            user(login: "#{user_login}") {
            name
            login
            repositories(#{first_option}, #{last_option}, #{next_page_option}, #{prev_page_option}, ownerAffiliations: OWNER, isFork: false) {
            nodes {
              name
              url
            }
            pageInfo {
              hasPreviousPage
              hasNextPage
              startCursor
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


      
      def next_page   
        getgit("after: \"#{params[:cursor_value]}\"", nil, "first: 20", nil)     
      end
      
      def prev_page
        getgit(nil, "before: \"#{params[:cursor_value]}\"", nil, "last: 20")
      end
      
end


