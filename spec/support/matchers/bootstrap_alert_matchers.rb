require 'rspec/expectations'

module BootstrapAlertMatchers
  extend RSpec::Matchers::DSL

  # success, danger, warning, info
  matcher :have_bs_alert do |text|
    match do |node|
      node.has_selector?('#flash .container.alert', text: text)
    end

    match_when_negated do |node|
      node.has_no_selector?('#flash .container.alert', text: text)
    end
  end
end
