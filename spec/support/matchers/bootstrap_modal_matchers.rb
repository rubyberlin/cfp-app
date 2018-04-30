require 'rspec/expectations'

module BootstrapModalMatchers
  extend RSpec::Matchers::DSL

  def have_bs_modal(title = nil, **options)
    have_selector(:bs_modal, title, **options)
  end
end
