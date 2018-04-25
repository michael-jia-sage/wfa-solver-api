# test
class AuthController < ApplicationController
  def index
    @url = "#{Rails.configuration.x.sage_auth_url}?response_type=code&client_id=#{Rails.configuration.x.sage_client_id}&redirect_uri=#{Rails.configuration.x.app_callback_url}&scope=full_access"
  end
end