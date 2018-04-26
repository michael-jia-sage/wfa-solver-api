require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module WfaApi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    # config.api_only = true
    config.x.sage_client_id = 'f1e220f4838245bdc6c2'
    config.x.sage_client_secret = '2bbbad86e63274adba1028f119e377573e5c254c'
    config.x.sage_signing_secret = '1924ea90d4796aa31a1c8c10caf566d4f8eac7a9'
    config.x.sage_token_url = 'https://oauth.na.sageone.com/token'
    config.x.app_callback_url = 'https://lyh-api.gameharbor.com.cn/callback'
    # config.x.app_callback_url = 'https://www.postly.com/callback'
    config.x.sage_auth_url = 'https://www.sageone.com/oauth2/auth/central'
    config.x.app_primary_key = '12e4a1d079f5407ea457184cc4d6c1ab'
  end
end
