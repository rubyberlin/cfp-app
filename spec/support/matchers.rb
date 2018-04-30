require 'support/matchers/bootstrap_alert_matchers'
require 'support/matchers/bootstrap_modal_matchers'

RSpec.configure do |config|
  config.include BootstrapAlertMatchers, type: :feature
  config.include BootstrapModalMatchers, type: :feature
end
