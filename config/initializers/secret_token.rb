# Be sure to restart your server when you modify this file.
require File.join(File.dirname(__FILE__), '..' , '..', 'vendor', 'plugins', 'thl_integration', 'lib', 'thl_cookie')

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
Mms::Application.config.secret_token = ThlCookie.session_secret