require 'spec_helper'
require 'rack/test'
require_relative '../../app'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  # Write your integration tests below.
  # If you want to split your integration tests
  # accross multiple RSpec files (for example, have
  # one test suite for each set of related features),
  # you can duplicate this test file to create a new one.

  context 'GET /' do
    it 'should get the homepage' do
      response = get('/')

      expect(response.status).to eq(200)
    end

    context 'not logged in' do
      it 'should show the login button when not logged in' do
        response = get('/', {}, { 'rack.session' => {} })

        expect(response.status).to eq(200)
        expect(response.body).to include('Log in')
      end
    end

    context 'logged in' do
      it 'should show the name of currently logged in user' do
        response = get('/', {}, { 'rack.session' => { user_id: '1' } })

        expect(response.status).to eq(200)
        expect(response.body).to include('Hello Joel')
      end
    end

    context 'spaces' do
      it 'returns list of spaces that are available on homescreen' do
        response = get('/')

        expect(response.status).to eq(200)
        expect(response.body).to include('Paradise Beach')
        expect(response.body).to include('£')
      end
    end
  end

  context 'GET /login' do
    it 'returns the login view if not logged in' do
      response = get('/login', {}, { 'rack.session' => {} })

      expect(response.status).to eq(200)
      expect(response.body).to include('<input name="username" placeholder="Username" required/>')
      expect(response.body).to include('<input name="password" placeholder="Password" type="password" required/>')
    end

    it 'redirects home if already logged in' do
      response = get('/login', {}, { 'rack.session' => { user_id: '1' } })

      expect(response).to be_redirect
      follow_redirect!
      expect(last_response.body).to include('Hello Joel')
    end
  end

  context 'GET /new_space' do
    context 'logged in' do
      it 'returns my_space view' do
        response = get('/new_space', {}, { 'rack.session' => { user_id: '1' } })

        expect(response.status).to eq(200)
        expect(response.body).to include('<input name="name" placeholder="Name" required/>')
        expect(response.body).to include('<input name="price" placeholder="Price" required/>')
        expect(response.body).to include('<input name="description" placeholder="Description" required/>')
      end
    end

    context 'not logged in' do
      it 'redirects to login view' do
        response = get('/new_space', {}, { 'rack.session' => {} })

        expect(response).to be_redirect
        follow_redirect!
        expect(last_response.body).to include('<input name="username" placeholder="Username" required/>')
        expect(last_response.body).to include('<input name="password" placeholder="Password" type="password" required/>')
      end
    end
  end

  context 'POST /login' do
    context 'given missing/incorrect parameters' do
      it 'returns 400' do
        response = post(
          '/login',
          username: 'joelio',
          pass: 'password1'
        )

        expect(response.status).to eq(400)
      end
    end

    context 'given valid username and password' do
      it 'redirects to homepage having logged in' do
        response = post(
          '/login',
          username: 'joelio',
          password: 'password1'
        )

        expect(response).to be_redirect
        follow_redirect!
        expect(last_response.body).to include('Hello Joel')
      end
    end

    context 'given invalid username and password' do
      it 'given an error message on login view' do
        response = post(
          '/login',
          username: 'joel',
          password: 'password'
        )

        expect(response.status).to eq(200)
        expect(response.body).to include('Username does not exist')
      end
    end

    context 'given invalid username' do
      it 'given an error message on login view' do
        response = post(
          '/login',
          username: 'joel',
          password: 'password1'
        )

        expect(response.status).to eq(200)
        expect(response.body).to include('Username does not exist')
      end
    end

    context 'given invalid password' do
      it 'given an error message on login view' do
        response = post(
          '/login',
          username: 'joelio',
          password: 'password'
        )

        expect(response.status).to eq(200)
        expect(response.body).to include('Password incorrect')
      end
    end
  end
end
