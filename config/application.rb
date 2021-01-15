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
    config.autoload_paths << Rails.root.join("lib")
    config.middleware.use I18n::JS::Middleware
    config.generators do |g|
      g.factory_bot dir: 'spec/factories'
    end
    config.active_job.queue_adapter = :sidekiq
  end
end

module Api
  class Application < Rails::Application
    config.middleware.use Rack::Cors do
      allow do
        origins "*"
        resource "*", headers: :any, methods: [:get,
          :post, :put, :delete, :options]
      end
    end
  end
end
