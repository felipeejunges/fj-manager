# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationJob, type: :job do
  describe 'perform' do
    it 'executes the job successfully' do
      expect { described_class.perform_sync }.not_to raise_error
    end
  end
end
