require 'simplecov'

SimpleCov.start do
  add_group "Models", "app/models"
  add_group "Controllers", "app/controllers"
  add_group "Services", "app/services"
  add_group "Sidekiq", "app/sidekiq"
  add_group "Views", "app/views"
  add_group "Helpers", "app/helpers"
  add_group "Presenters", "app/presenters"
  add_group "Policies", "app/policies"
  add_filter "spec"
  add_filter "config"
  add_filter "db"
end

require 'rspec-sidekiq'
require 'capybara/rspec'
require 'selenium-webdriver'

selenium_host = ENV.fetch('SELENIUM_HOST', 'localhost')
selenium_port = ENV.fetch('SELENIUM_PORT', '4444')


Capybara.register_driver :headless_selenium_chrome_in_container do |app|
  options = ::Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless')
  options.add_argument('--disable-gpu')
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage')
  options.add_argument('--window-size=1440x768')

  Capybara::Selenium::Driver.new(app,
    :browser => :chrome,
    url: "http://#{selenium_host}:#{selenium_port}/wd/hub",
    options: options
  )
end

#Capybara.default_max_wait_time = 5

# This file was generated by the `rails generate rspec:install` command. Conventionally, all
# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# The generated `.rspec` file contains `--require spec_helper` which will cause
# this file to always be loaded, without a need to explicitly require it in any
# files.
#
# Given that it is always loaded, you are encouraged to keep this file as
# light-weight as possible. Requiring heavyweight dependencies from this file
# will add to the boot time of your test suite on EVERY test run, even for an
# individual file that may not need all of that loaded. Instead, consider making
# a separate helper file that requires the additional dependencies and performs
# the additional setup, and require it from the spec files that actually need
# it.
#
# See https://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  # rspec-expectations config goes here. You can use an alternate
  # assertion/expectation library such as wrong or the stdlib/minitest
  # assertions if you prefer.
  config.expect_with :rspec do |expectations|
    # This option will default to `true` in RSpec 4. It makes the `description`
    # and `failure_message` of custom matchers include text for helper methods
    # defined using `chain`, e.g.:
    #     be_bigger_than(2).and_smaller_than(4).description
    #     # => "be bigger than 2 and smaller than 4"
    # ...rather than:
    #     # => "be bigger than 2"
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended, and will default to
    # `true` in RSpec 4.
    mocks.verify_partial_doubles = true
  end

  # This option will default to `:apply_to_host_groups` in RSpec 4 (and will
  # have no way to turn it off -- the option exists only for backwards
  # compatibility in RSpec 3). It causes shared context metadata to be
  # inherited by the metadata hash of host groups and examples, rather than
  # triggering implicit auto-inclusion in groups with matching metadata.
  config.shared_context_metadata_behavior = :apply_to_host_groups

# The settings below are suggested to provide a good initial experience
# with RSpec, but feel free to customize to your heart's content.
=begin
  # This allows you to limit a spec run to individual examples or groups
  # you care about by tagging them with `:focus` metadata. When nothing
  # is tagged with `:focus`, all examples get run. RSpec also provides
  # aliases for `it`, `describe`, and `context` that include `:focus`
  # metadata: `fit`, `fdescribe` and `fcontext`, respectively.
  config.filter_run_when_matching :focus

  # Allows RSpec to persist some state between runs in order to support
  # the `--only-failures` and `--next-failure` CLI options. We recommend
  # you configure your source control system to ignore this file.
  config.example_status_persistence_file_path = "spec/examples.txt"

  # Limits the available syntax to the non-monkey patched syntax that is
  # recommended. For more details, see:
  # https://rspec.info/features/3-12/rspec-core/configuration/zero-monkey-patching-mode/
  config.disable_monkey_patching!

  # Many RSpec users commonly either run the entire suite or an individual
  # file, and it's useful to allow more verbose output when running an
  # individual spec file.
  if config.files_to_run.one?
    # Use the documentation formatter for detailed output,
    # unless a formatter has already been configured
    # (e.g. via a command-line flag).
    config.default_formatter = "doc"
  end

  # Print the 10 slowest examples and example groups at the
  # end of the spec run, to help surface which specs are running
  # particularly slow.
  config.profile_examples = 10

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = :random

  # Seed global randomization in this process using the `--seed` CLI option.
  # Setting this allows you to use `--seed` to deterministically reproduce
  # test failures related to randomization by passing the same `--seed` value
  # as the one that triggered the failure.
  Kernel.srand config.seed
=end
  config.before(:each, type: :system) do
    Capybara::DSL
    Capybara.server_host = '0.0.0.0'
    Capybara.server_port = 4000
    Capybara.app_host = ENV.fetch('APP_HOST', 'http://localhost:4000')
    Capybara.always_include_port = true
    driven_by(:headless_selenium_chrome_in_container)
  end

  RSpec.configure do |config|
   # config.include Sorcery::TestHelpers::Rails::Controller, type: :controller
    #config.include Sorcery::TestHelpers::Rails::Request, type: :request
    #config.include Sorcery::TestHelpers::Rails::Integration, type: :feature
  end

  config.after(:each, type: :system) do
    Capybara.reset_sessions!
  end

  config.before(:suite) do
    DatabaseCleaner[:active_record].strategy = :truncation
    DatabaseCleaner.clean
    Rails.application.load_seed
  end

  config.before(:each) do
    DatabaseCleaner[:active_record].strategy = :truncation, { except: %w[roles permissions]}
    DatabaseCleaner[:mongoid].strategy = [:deletion]
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.example_status_persistence_file_path = 'rspec.txt'
end

RSpec::Sidekiq.configure do |config|
  # Clears all job queues before each example
  config.clear_all_enqueued_jobs = true # default => true

  # Whether to use terminal colours when outputting messages
  config.enable_terminal_colours = true # default => true

  # Warn when jobs are not enqueued to Redis but to a job array
  config.warn_when_jobs_not_processed_by_sidekiq = false # default => true
end
