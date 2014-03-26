require Rails.root.join('config', 'environments', 'production')

ConsoleRails::Application.configure do
	config.assets.prefix = "/staging/assets"
  config.action_dispatch.tld_length = 2
end
