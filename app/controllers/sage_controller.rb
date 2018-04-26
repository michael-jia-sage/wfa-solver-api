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
    base_url = 'https://api.columbus.sage.com/ca/sageone/accounts/v3/ledger_entries?items_per_page=200&attributes=all'
    response = RestClient.get(base_url, header)
    @response = JSON.parse(response.to_s)
    render json: @response
  end

  def tax_rates
    base_url = 'https://api.columbus.sage.com/ca/sageone/accounts/v3/tax_rates'
    response = RestClient.get(base_url, header)
    @response = JSON.parse(response.to_s)
    render json: @response
  end

  def invoices
    base_url = 'https://api.columbus.sage.com/ca/sageone/accounts/v3/sales_invoices'
    data = invoice_pay_load
    response = RestClient.post(base_url, data ,header)
    @response = JSON.parse(response.to_s)
    render json: @response
  end


  private

  def invoice_pay_load
    {"sales_invoice" =>
      {
      "contact_id" => "64b278f848b811e8a8f11281a7acf536",
      "date" => "2018-04-25",
      "due_date" => "2018-05-25",
      "invoice_lines" => [
        {
          "description" => "testing wehat",
          "ledger_account_id" => "7431af3648a311e8a8f11281a7acf536",
          "quantity" => 3,
          "unit_price" => 10
        }
      ]
      "notes" => "notes dsfdfs",
      "reference" => "ref test 001"
     }
    }
  end

 # def invoice_payload
 #   {
 #       contact_id: "64b278f848b811e8a8f11281a7acf536",
 #       reference: "Trx#: #{params["trans_id"]}",
 #       date: params["date_time"],
 #       notes: "Payment received from WeChat for #{params["memo"]}",
 #       invoice_lines: [line_item_payload]
 #   }
 # end

 def line_item_payload
   {
       description: params["memo"],
       ledger_account_id: "ccc159a948ac11e8a8f11281a7acf536",
       quantity: 1,
       unit_price: params["amount"]
   }
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