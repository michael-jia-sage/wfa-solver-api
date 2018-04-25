# test
class CallbackController < ApplicationController
    def index
      # render json: { client_id: Rails.configuration.x.sage_client_id }
      response = RestClient.post(
        Rails.configuration.x.sage_token_url,
        payload
      )
      process_token(response)
      redirect_to '/callback/success'
    end

    def success
        render json: {success: true}
    end


    private


    def payload
      {
        code: params[:code],
        client_id:   Rails.configuration.x.sage_client_id,
        client_secret: Rails.configuration.x.sage_client_secret,
        grant_type: 'authorization_code',
        redirect_uri: Rails.configuration.x.app_callback_url
      }
    end

    def process_token(response)
      Rails.logger.debug("My object: #{response}")
      json = JSON.parse(response.body)
      Rails.logger.debug("My object: #{json}")
      Token.create(token: json['access_token'], refresh_token: json['refresh_token'], resource_id: json['resource_owner_id'])
    end
  end
