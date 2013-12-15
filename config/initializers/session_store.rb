# Be sure to restart your server when you modify this file.

ConsoleRails::Application.config.session_store :cookie_store, key: ENV['COOKIE_NAME'], domain: ENV['COOKIE_DOMAIN'], secret_key_base: ENV['COOKIE_SECRET']
