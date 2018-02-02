class CaltestController < ApplicationController
# GET /caltest
  def index
    json_response(value: 'I am good')
  end

  # POST /caltest
  def create
    response = RestClient::Request.execute(
      method: :get,
      url: "#{APP_CONFIG['wfa_api_url']}#{cal_query_string}"
    )
    json_response(Hash.from_xml(response).to_json)
  end

  private

  def caltest_params
    # whitelist params
    params.permit(:qtype, :qparams)
  end

  def cal_query_string
    "/query?input=#{cal_input}&appid=#{APP_CONFIG['wfa_app_id']}"\
    "&assumption=#{cal_assumption}&format=#{cal_format}"\
    "&includepodid=#{cal_include_pod_id}&excludepodid=#{cal_exclude_pod_id}"
  end

  def cal_input
    'pi'
  end

  def cal_assumption
    # '*C.pi-_*Movie-'
    ''
  end

  def cal_format
    ''
  end

  def cal_include_pod_id
    ''
  end

  def cal_exclude_pod_id
    ''
  end


end
