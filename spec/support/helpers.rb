require 'support/helpers/bootstrap_modal_helpers'
require 'support/helpers/session_helpers'

RSpec.configure do |config|
  config.include BootstrapModalHelpers, type: :feature
  config.include Features::SessionHelpers, type: :feature
end
