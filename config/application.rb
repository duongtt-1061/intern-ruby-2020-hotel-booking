require_relative "boot"

require "rails/all"
Bundler.require(*Rails.groups)

module InternRuby2020HotelBooking
  class Application < Rails::Application
    config.load_defaults 6.0
    config.i18n.load_path += Dir[Rails.root
      .join("config", "locales", "**", "*.{rb,yml}")]
    config.i18n.available_locales = [:en, :vi]
    config.i18n.default_locale = :vi
    config.action_view.embed_authenticity_token_in_remote_forms = true
    config.middleware.use I18n::JS::Middleware
    config.generators do |g|
      g.factory_bot dir: 'spec/factories'
    end
  end
end
