# frozen_string_literal: true

require 'factory_bot_rails'

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  # config.before(:suite) do
  #  FactoryBot.reload
  # end

  # Dir[Rails.root.join('spec', 'factories', '**', '*.rb')].each { |f| require f }
end
