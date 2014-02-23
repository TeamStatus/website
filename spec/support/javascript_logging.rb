require 'selenium/webdriver'

# we need a firefox extension to start intercepting javascript errors before the page
# scripts load
Capybara.register_driver :selenium do |app|
  profile = Selenium::WebDriver::Firefox::Profile.new
  # see https://github.com/mguillem/JSErrorCollector
  profile.add_extension File.join(Rails.root, "spec/support/extensions/JSErrorCollector.xpi")
  Capybara::Selenium::Driver.new app, :profile => profile
end

RSpec.configure do |config|
  config.after(:each, :type => :feature) do
    if page.driver.to_s.match("Selenium")
      errors = page.execute_script("return window.JSErrorCollector_errors.pump()")

      if errors.any?
        puts '-------------------------------------------------------------'
        puts "Found #{errors.length} javascript #{pluralize(errors.length, 'error')}"
        puts '-------------------------------------------------------------'
        errors.each do |error|
          puts "    #{error["errorMessage"]} (#{error["sourceName"]}:#{error["lineNumber"]})"
        end
        raise "Javascript #{pluralize(errors.length, 'error')} detected, see above"
      end
    end
  end
end
