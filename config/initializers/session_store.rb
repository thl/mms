# Be sure to restart your server when you modify this file.

Mms::Application.config.session_store :cookie_store, :key => ThlCookie.session_key #, :domain => '.thlib.org'

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Kmaps::Application.config.session_store :active_record_store