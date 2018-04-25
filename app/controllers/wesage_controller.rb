class WesageController < ApplicationController
  # GET /solve
  def index
    json_response(value: 'I am the great Wesage API.')
  end
end
