# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Client Plans Index Page', type: :system do
  let(:password) { '123' }
  let(:admin_user) { create(:user, :admin, password:, password_confirmation: password) }
  let!(:client_plans) { create_list(:client_plan, 3) }
  let!(:client_plan) { client_plans.first }

  before do
    login(admin_user.email, admin_user.password)
    visit clients_path
    visit client_plans_path
  end

  it 'Admin views the list of client plans' do
    expect(page).to have_content('Plans')

    client_plans.each do |client_plan|
      expect(page).to have_content(client_plan.name)
      expect(page).to have_content(client_plan.price)
      expect(page).to have_content(client_plan.start_date)
    end
  end

  it 'Admin navigates to the show page of a client plan' do
    click_link client_plan.name, href: client_plan_path(client_plan)

    expect(current_path).to eq(client_plan_path(client_plan))
    expect(page).to have_content(client_plan.name)
  end
end
