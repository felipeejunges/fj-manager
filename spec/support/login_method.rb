# frozen_string_literal: true

def login(email, password = '123')
  visit login_path

  fill_in 'Email', with: email
  fill_in 'Password', with: password
  click_button 'Sign in'
end
