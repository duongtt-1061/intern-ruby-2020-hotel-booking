Devise.setup do |config|
  config.mailer_sender = ENV["email"]
  require 'devise/orm/active_record'
  # config.authentication_keys = [:email]
  # config.request_keys = []
  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]
  # config.params_authenticatable = true
  # config.http_authenticatable = false
  # config.http_authenticatable_on_xhr = true
  # config.http_authentication_realm = 'Application'
  # config.paranoid = true
  config.skip_session_storage = [:http_auth]
  # config.clean_up_csrf_token_on_authentication = true
  # config.reload_routes = true
  config.stretches = Rails.env.test? ? 1 : 12
  # config.pepper = '34088cfd23a558182ff160094ce7afb19b1f86187d7aae7e91ff170c9d56d5ec8a8959c47a26ea4e0f832be5f5799c5def3fbbfac2282954d318faa40504d6b8'
  # config.send_email_changed_notification = false
  # config.send_password_change_notification = false
  # config.allow_unconfirmed_access_for = 2.days
  # config.confirm_within = 3.days
  config.reconfirmable = true
  # config.confirmation_keys = [:email]
  # config.remember_for = 2.weeks
  config.expire_all_remember_me_on_sign_out = true
  # config.extend_remember_period = false
  # config.rememberable_options = {}
  config.password_length = 6..128
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/
  # config.timeout_in = 30.minutes
  config.lock_strategy = :failed_attempts
  config.unlock_keys = [:time]
  config.unlock_strategy = :time
  config.maximum_attempts = 5
  config.unlock_in = 30.minutes
  # config.last_attempt_warning = true
  # config.reset_password_keys = [:email]
  config.reset_password_within = 6.hours
  # config.sign_in_after_reset_password = true
  # config.encryptor = :sha512
  # config.scoped_views = false
  # config.default_scope = :user
  # config.sign_out_all_scopes = true
  config.sign_out_via = :delete
  # config.warden do |manager|
  #   manager.intercept_401 = false
  #   manager.default_strategies(scope: :user).unshift :some_external_strategy
  # end
  # config.router_name = :my_engine
  # config.omniauth_path_prefix = '/my_engine/users/auth'
  # ActiveSupport.on_load(:devise_failure_app) do
  #   include Turbolinks::Controller
  # end
  # config.sign_in_after_change_password = true
  config.omniauth :facebook, "302248397896756", "e5cf4c1a75e40d89a1493655b914c565", scope: 'email', info_fields: 'email,name'
  config.omniauth :google_oauth2, "297460403504-3id7ddhb1tekts9ds848fn7csbs1m54f.apps.googleusercontent.com", "Es_wdvdOXzpBbAGjrImnpsgl", scope: 'email', info_fields: 'email,name'
end
