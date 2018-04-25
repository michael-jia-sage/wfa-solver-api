# test
class SageController < ApplicationController
 def index
   base_url = 'https://api.columbus.sage.com/ca/sageone/accounts/v3/contacts'
#    @signer = SageoneApiSigner.new({
#         request_method: 'get',
#         url: base_url,
#         body_params: {},
#         signing_secret: Rails.configuration.x.sage_signing_secret,
#         access_token: Token.last.token
#     })
#     Rails.logger.debug("My object: #{@signer}")

    # header =
    response = RestClient.get(base_url, header)
    @response = JSON.parse(response.to_s)
    render json: @response
 end

  def ledger_entries
    base_url = 'https://api.columbus.sage.com/ca/sageone/accounts/v3/ledger_entries'
    response = RestClient.get(base_url, header)
    @response = JSON.parse(response.to_s)
    render json: @response
  end

  def invoice

  end


  private

  def invoice_pay_load
  end

  def header
    {
        "Authorization" => "Bearer #{Token.last.token}",
        "ocp-apim-subscription-key" => Rails.configuration.x.app_primary_key,
        "X-Site" => Token.last.resource_id,
        "Content-Type" => "application/json"
    }
  end
end