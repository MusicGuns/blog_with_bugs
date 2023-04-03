require 'rails_helper'

RSpec.describe 'create post', type: :feature do
  let(:user) { User.create(email: 'user@example.com', password: 'password') }

  context 'when user is sign in' do
    before do
      sign_in user
    end

    it 'creates post with valid inputs' do
      visit '/posts/new'

      expect(page).to have_current_path '/posts/new'

      within('#new_post') do
        fill_in 'post_title', with: 'Posts'
        fill_in 'post_html_body', with: 'qwerty'
      end

      click_button 'Save'

      expect(page).to have_current_path '/posts/1'
      expect(page).to have_content 'Post was created'
      expect(page).to have_content 'Posts'
      expect(page).to have_content 'qwerty'
      expect(page).to have_link 'Edit post'
      expect(page).to have_link 'Delete post'
    end

    it 'doesnt create post with title too long' do
      visit '/posts/new'

      expect(page).to have_current_path '/posts/new'

      within('#new_post') do
        fill_in 'post_title', with: 'aa' * 101
        fill_in 'post_html_body', with: 'qwerty'
      end

      click_button 'Save'

      expect(page).to have_current_path '/posts'
      expect(page).to have_content 'Title is too long'
    end

    it 'doesnt create post with title too short' do
      visit '/posts/new'

      expect(page).to have_current_path '/posts/new'

      within('#new_post') do
        fill_in 'post_title', with: ''
        fill_in 'post_html_body', with: 'qwerty'
      end

      click_button 'Save'

      expect(page).to have_current_path '/posts'
      expect(page).to have_content 'Title is too short (minimum is 5 characters)'
    end

    it 'doesnt create post with blank title and html body' do
      visit '/posts/new'

      expect(page).to have_current_path '/posts/new'

      within('#new_post') do
        fill_in 'post_title', with: ''
        fill_in 'post_html_body', with: ''
      end

      click_button 'Save'

      expect(page).to have_current_path '/posts'
      expect(page).to have_content 'Title can\'t be blank and Title is too short (minimum is 5 characters)'
      expect(page).to have_content 'Html body can\'t be blank'
    end
  end

  context 'when user is not sign in' do
    it 'kick user to page sign_in' do
      visit '/posts/new'

      expect(page).to have_current_path '/users/sign_in'
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end
