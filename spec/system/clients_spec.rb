require 'rails_helper'

RSpec.feature 'Clients Page', type: :system do
  let(:password) { '123' }
  let(:user) { create(:user, :admin, password: password) }
  let!(:clients) { create_list(:client, 5) }
  let!(:client) { clients.first }

  it 'displays clients list' do 
    login(user.email, password)
    visit clients_path

    clients.each do |client|
      expect(page).to have_content(client.name)
    end
  end

  it 'allows user to navigate to client details page' do
    login(user.email, password)
    visit clients_path
    click_on clients.first.name
    expect(page).to have_content(client.name)
  end

  it 'deletes the client' do
    login(user.email, password)
    visit clients_path
    within("table tbody") do |tbody|
      first('tr') do |tr|
        all('td').last do |td|
          click(all('a').last)
          page.accept_confirm
          expect(page).to have_content('Client was successfully destroyed.')
          expect(Client.count).to eq(4)
        end
      end
    end
  end

  context "Editing a client" do
    it 'displays the edit form' do
      login(user.email, password)
      visit clients_path
      visit edit_client_path(client)
      expect(page).to have_content("Editing #{client.name}")
      expect(page).to have_field('Name', with: client.name)
    end

    it 'updates the client' do
      login(user.email, password)
      visit clients_path
      visit edit_client_path(client)
      fill_in 'Name', with: 'Updated Client Name'
      click_button 'Save'
      expect(page).to have_content('Client was successfully updated.')
      expect(page).to have_content('Updated Client Name')
    end
  end
end