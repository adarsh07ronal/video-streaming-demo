require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module VideoStreamingApi
  class Application < Rails::Application
    config.load_defaults 8.1

    # ADD THIS LINE 👇 (THIS FIXES YOUR ERROR)
    config.autoload_paths << Rails.root.join("app/services")

    config.autoload_lib(ignore: %w[assets tasks])

    config.api_only = true
  end
end

