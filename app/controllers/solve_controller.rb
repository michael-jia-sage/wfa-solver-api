class SolveController < ApplicationController
  # GET /solve
  def index
    json_response(value: 'I am the greatest equation solver.')
  end

  # POST /solve
  def create
    unless params['e1_left']
      return json_response({:response => 'Missing equation' }, 406)
    end

    response = RestClient::Request.execute(
      method: :get,
      url: "#{APP_CONFIG['wfa_api_url']}#{solve_query_string}"
    )
    json_response(res_body(response))
  end

  private

  def solve_query_string
    "/query?input=#{euqations_input}&appid=#{APP_CONFIG['wfa_app_id']}"\
    "&assumption=#{cal_assumption}&format=#{cal_format}"\
    "&includepodid=#{cal_include_pod_id}&excludepodid=#{cal_exclude_pod_id}"
  end

  def get_param_value(key)
    params[key] ? params[key] : '0'
  end

  def euqations_input
    e2 = params[:e2_left] ? ";#{params[:e2_left]}%3D#{get_param_value(:e2_right)}" : ""
    e3 = params[:e3_left] ? ";#{params[:e3_left]}%3D#{get_param_value(:e3_right)}" : ""
    "#{params[:e1_left]}%3D#{get_param_value(:e1_right)}#{e2}#{e3}".gsub('+', '%2B')
  end

  def cal_assumption
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

  def res_body(response)
    hash_res = Hash.from_xml(response)
    qresult = hash_res["queryresult"]
    error = qresult["error"] == 'true'
    return { error: true, message: qresult["message"] } if error

    hash_res.to_json
  end

end
