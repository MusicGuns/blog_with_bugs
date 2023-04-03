require 'rails_helper'

RSpec.describe 'sign up', type: :feature do
  it 'sign up with valid email and password' do
    visit '/users/sign_up'

    expect(page).to have_current_path '/users/sign_up'

    within('#new_user') do
      fill_in 'user_email', with: 'example@example.ru'
      fill_in 'user_password', with: 'password'
      fill_in 'user_password_confirmation', with: 'password'
    end

    click_button 'Sign up'

    expect(page).to have_current_path '/'
    expect(page).to have_content 'Logged in as example@example.ru | Home | Profile | Log out'
    expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(User.last.email).to eq 'example@example.ru'
  end

  it 'doesnt sign up with invalid email' do
    visit '/users/sign_up'

    expect(page).to have_current_path '/users/sign_up'

    within('#new_user') do
      fill_in 'user_email', with: 'example@example..ru'
      fill_in 'user_password', with: 'password'
      fill_in 'user_password_confirmation', with: 'password'
    end

    click_button 'Sign up'

    expect(page).to have_current_path '/users'
    expect(page).to have_content 'Email is invalid'
    expect(User.last).to be_nil
  end

  it 'doesnt sign up with blank password' do
    visit '/users/sign_up'

    expect(page).to have_current_path '/users/sign_up'

    within('#new_user') do
      fill_in 'user_email', with: 'example@example.ru'
      fill_in 'user_password', with: ''
      fill_in 'user_password_confirmation', with: ''
    end

    click_button 'Sign up'

    expect(page).to have_current_path '/users'
    expect(page).to have_content 'Password can\'t be blank'
    expect(User.last).to be_nil
  end
end
