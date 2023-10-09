require 'rails_helper'

RSpec.feature 'Clients Report Page', type: :system do
  let(:password) { '123' }
  let(:user) { create(:user, :admin, password:) }
  let!(:clients) { create_list(:client, 5) }

  it 'displays clients' do
    login(user.email, password)
    visit clients_path
    visit reports_clients

    expect(page).to have_content('Clients report')
    clients.each do |client|
      expect(page).to have_content(client.name)
    end
  end
end
