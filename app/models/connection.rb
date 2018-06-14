class Connection < ApplicationRecord
  belongs_to :user

  class AuthorizationError < StandardError
  end

  # AUTH_URL = 'https://accounts.google.com'.freeze
  # OAUTH_AUTH_PATH = '/o/oauth2/auth'.freeze
  # OAUTH_TOKEN_PATH = '/o/oauth2/token'.freeze
  # APIS_URL = 'https://www.googleapis.com'.freeze
  # DRIVE_API_PREFIX = '/drive/v2'.freeze
  TOKEN_TYPE  = 'Bearer'.freeze
  AUTH_URL    = 'https://www.dropbox.com'.freeze
  TOKEN_URL   = 'https://api.dropboxapi.com'.freeze
  RPC_URL     = 'https://api.dropboxapi.com'.freeze
  CONTENT_URL = 'https://content.dropboxapi.com'.freeze
  AUTH_PATH   = '/oauth2/authorize'.freeze
  TOKEN_PATH  = '/oauth2/token'.freeze
  API_PREFIX  = '/2'.freeze

  def redirect_url_for_oauth
    connection(:authorize).build_url(AUTH_PATH, request_params(:authorize)).to_s
  end

  def fetch_access_token authorization_params
    authorization_code = parse_response :authorize, authorization_params
    token = request action: :callback, args_to_params: authorization_code
    update token
    ''
  rescue AuthorizationError => e
    e
  end

  def refresh!
  end

  def download_file fname
    request_api action: :download, args_to_headers: fname
  end

  def upload_file fname, contents
    request_api action: :upload, args_to_params: contents, args_to_headers: fname
  end

  def delete_file fname
    request_api action: :delete, args_to_params: fname
  end

  def list_files
    request_api action: :list
  end

  def list_files_continue cursor
    request_api action: :list_continue, args_to_params: cursor
  end

  private

  def request action: nil, path: nil, params: nil, headers: {}, path_prefix: nil, args_to_params: nil, args_to_headers: nil
    res = connection(action).send http_method(action),
      "#{path_prefix}#{path || request_path(action)}",
      params || request_params(action, args_to_params),
      request_headers(action, args_to_headers).merge(headers)
    parse_response action, res
  end

  def request_api action: nil, path: nil, params: nil, args_to_params: nil, args_to_headers: nil
    request action: action,
      path: path,
      params: params,
      headers: { authorization: "#{TOKEN_TYPE} #{access_token}" },
      path_prefix: API_PREFIX,
      args_to_params: args_to_params,
      args_to_headers: args_to_headers
  end

  def connection action_name
    make_connection select_url(action_name), faraday_functor(action_name)
  end

  def make_connection url, functor
    Faraday.new url: url do |faraday|
      functor.call faraday
      faraday.adapter Faraday.default_adapter
    end
  end

  def faraday_functor action_name
    case action_name
    when :authorize
      -> faraday {}
    when :download
      -> faraday {
        faraday.request :url_encoded
      }
    when :callback, :upload
      -> faraday {
        faraday.request :url_encoded
        faraday.response :json
      }
    when :list, :list_continue, :delete
      -> faraday {
        faraday.request :json
        faraday.request :url_encoded
        faraday.response :json
      }
    end
  end

  def select_url action_name
    case action_name
    when :authorize
      AUTH_URL
    when :callback
      TOKEN_URL
    when :download, :upload
      CONTENT_URL
    when :list, :list_continue, :delete
      RPC_URL
    end
  end

  def http_method action
    case action
    when :callback, :download, :upload, :list, :list_continue, :delete
      :post
    end
  end

  def request_path action
    case action
    when :callback
      TOKEN_PATH
    when :download
      '/files/download'
    when :upload
      '/files/upload'
    when :delete
      '/files/delete_v2'
    when :list
      '/files/list_folder'
    when :list_continue
      '/files/list_folder/continue'
    end
  end

  def request_params kind, params = nil
    case kind
    when :authorize
      params_for_authorization_code
    when :callback
      params_for_token params
    when :upload
      params_for_upload_file params
    when :delete
      params_for_delete_file params
    when :list
      params_for_list_directories
    when :list_continue
      params_for_list_continue params
    else
      nil
    end
  end

  def request_headers action, params = nil
    case action
    when :download
      {
        content_type: 'text/plain; charset=utf-8',
        dropbox_api_arg: %({"path": "/#{params}"}),
      }
    when :upload
      {
        content_type: 'application/octet-stream',
        dropbox_api_arg: %({"path": "/#{params}", "mode": "overwrite", "autorename": false, "mute": true}),
      }
    when :list, :list_continue, :delete
      {
        content_type: 'application/json',
      }
    else
      {}
    end
  end

  def params_for_authorization_code
    {
      response_type: 'code',
      client_id: client_id,
      redirect_uri: connections_callback_url,
      state: generate_state,
      require_role: 'personal',
      locale: 'ja-JP',
    }
  end

  def params_for_token code
    {
      code: code,
      grant_type: 'authorization_code',
      client_id: client_id,
      client_secret: client_secret,
      redirect_uri: connections_callback_url,
    }
  end

  def params_for_delete_file fname
    {
      path: "/#{fname}",
    }
  end

  def params_for_list_directories
    {
      path: '',
      recursive: true,
      include_media_info: false,
      include_deleted: false,
      include_has_explicit_shared_members: false,
      include_mounted_folders: true,
    }
  end

  def params_for_list_continue cursor
    {
      cursor: cursor,
    }
  end

  def params_for_upload_file contents
    contents
  end

  def connections_callback_url
    Rails.application.routes.url_helpers.connections_callback_url
  end

  def generate_state
    user.id
  end

  def client_id
    Rails.application.secrets.dropbox[:client_id]
  end

  def client_secret
    Rails.application.secrets.dropbox[:client_secret]
  end

  def parse_response action, response
    raise AuthorizationError, response[:error_description] if response.is_a?(Hash) && response[:error].present?

    case action
    when :authorize
      parse_authorization_code response
    when :callback
      parse_access_token response.body
    when :list
      parse_list_files response.body
    else
      response.body
    end
  end

  def parse_authorization_code response
    response[:code] || response['code']
  end

  def parse_access_token response
    {
      access_token: response[:access_token] || response['access_token'],
    }
  end

  def parse_list_files response
    files = response['entries']
    while response['has_more']
      response = list_continue response['cursor']
      files.concat response['entries']
    end
    files
  end
end
