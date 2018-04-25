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
    e2 = params[:e2_left].blank? ? "" : ";#{params[:e2_left]}%3D#{get_param_value(:e2_right)}"
    e3 = params[:e3_left].blank? ? "" : ";#{params[:e3_left]}%3D#{get_param_value(:e3_right)}"
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
    error = qresult["error"] == 'true' || qresult["success"] == 'false'
    return { error: true, message: qresult["message"] } if error

    solutions = qresult['pod'].find { |s| s['title'].include?('Solution') }
    if solutions
      subpod = solutions['subpod']
      real_roots = subpod.is_a?(Hash) ? [subpod['plaintext']] : subpod.map { |s| s['plaintext'] }
      return { error: false, real_roots: real_roots }
    end

    real_solutions = qresult['pod'].find { |s| s['title'].include?('Real solution') }
    if real_solutions
      subpod = real_solutions['subpod']
      real_roots = subpod.is_a?(Hash) ? [subpod['plaintext']] : subpod.map { |s| s['plaintext'] }
    else
      real_roots = nil
    end
    complex_solutions = qresult['pod'].find { |s| s['title'].include?('Complex solution') }
    if complex_solutions
      subpod = complex_solutions['subpod']
      complex_roots = subpod.is_a?(Hash) ? [subpod['plaintext']] : subpod.map { |s| s['plaintext'] }
    else
      complex_roots = nil
    end
    { error: false, real_roots: real_roots, complex_roots: complex_roots }

  end

end
