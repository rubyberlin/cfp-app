require 'capybara/chromedriver/logger'

Capybara.configure do |config|
  config.default_max_wait_time = 5
end

Capybara::Chromedriver::Logger.filters = [
  /Download the React DevTools/i,
  /JQMIGRATE: Migrate is installed with logging active/i
]

Capybara.javascript_driver = :selenium_chrome_headless_no_sandbox

Capybara.register_driver :selenium_chrome_headless_no_sandbox do |app|
  browser_options = ::Selenium::WebDriver::Chrome::Options.new
  browser_options.args << '--headless'
  browser_options.args << '--disable-gpu'
  browser_options.args << '--no-sandbox'

  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    loggingPrefs: {
      browser: 'ALL'
    }
  )

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: browser_options, desired_capabilities: capabilities)
end

