# frozen_string_literal: true

def login(email, password = '123')
  visit login_path

  find(:css, '.login-card')
  fill_in 'Email', with: email
  fill_in 'Password', with: password
  find_button('Sign in').click
  sleep(0.1)
end
