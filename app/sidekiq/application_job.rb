# frozen_string_literal: true

class ApplicationJob
  include Sidekiq::Job

  def perform(*args)
    # Do something
  end
end
