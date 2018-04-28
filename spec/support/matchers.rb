require 'support/matchers/bootstrap_alert_matchers'

RSpec.configure do |config|
  config.include BootstrapAlertMatchers, type: :feature
end
