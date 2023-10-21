# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ClientsHelper, type: :helper do
  let!(:client) { create(:client) }
  it 'calculates percentage difference correctly' do
    number1 = 2000
    number2 = 2500

    expected_comparisson = ((number2 - number1).to_f / number1) * 100

    expect(client.calculate_percentage_difference(number1, number2)).to eq(expected_comparisson)
  end
end
