require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module ConsoleRails
  class Application < Rails::Application
	# Settings in config/environments/* take precedence over those specified here.
	# Application configuration should go into files in config/initializers
	# -- all .rb files in that directory are automatically loaded.

	# Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
	# Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
	# config.time_zone = 'Central Time (US & Canada)'

	# The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
	# config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
	# config.i18n.default_locale = :de

	# Enabled Rails's static asset server
	config.serve_static_files = true

	# Add the fonts path
	config.assets.paths << Rails.root.join('app', 'assets', 'fonts')
	config.assets.precompile += %w( .svg .eot .woff .ttf )
	config.assets.precompile << Proc.new do |path|
	  if path =~ /\.(css|js)\z/
		full_path = Rails.application.assets.resolve(path).to_path
		app_assets_path = Rails.root.join('app', 'assets').to_path
		if full_path.starts_with? app_assets_path
		  puts "including asset: " + full_path
		  true
		else
		  # puts "excluding asset: " + full_path
		  false
		end
	  else
		false
	  end
	end
	config.assets.precompile << 'plugins/html5shiv/dist/html5shiv.js'
	config.assets.precompile << 'plugins/respond/respond.min.js'
	config.assets.precompile << 'plugins/retina/js/retina-1.1.0.min.js'

	initializer :after_append_asset_paths,
		  :group => :all,
		  :after => :append_assets_path do
		# serving fonts right from flexslider/fonts
		config.assets.paths.unshift Rails.root.join("vendor", "assets", "javascripts", "plugins", "flexslider").to_s
	  end
  end
end
