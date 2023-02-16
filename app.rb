require 'sinatra/base'
require 'sinatra/reloader'
require_relative 'lib/user_repository'
require_relative 'lib/space_repository'
require_relative 'lib/booking_repository'
require_relative 'lib/database_connection'
require_relative 'lib/user'

class Application < Sinatra::Base
  enable :sessions

  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    current_user_id = session[:user_id]

    if current_user_id
      user_repo = UserRepository.new
      @user = user_repo.find('id', current_user_id)
    end

    repo = SpaceRepository.new
    @spaces = repo.find_all('available', true)

    erb(:index)
  end

  get '/signup' do
    erb(:signup)
  end

  post '/signup' do
    repo = UserRepository.new
    new_user = User.new
    new_user.name = params[:name]
    new_user.username = params[:username]
    new_user.email = params[:email]
    new_user.password = params[:password]

    repo.create(new_user)

    return erb(:login)
  end

  get '/login' do
    redirect('/') if session[:user_id]

    erb(:login)
  end

  get '/my_spaces/new' do
    redirect('/login') unless session[:user_id]

    erb(:new_space)
  end

  post '/my_spaces/new' do
    return status 400 unless %i[name price description].all? { |param| params.key?(param) }

    repo = SpaceRepository.new

    space = Space.new
    space.name = params[:name]
    space.available = true
    space.description = params[:description]
    space.price = params[:price]
    space.user_id = session[:user_id]

    repo.create(space)

    redirect '/my_spaces'
  end

  get '/my_spaces' do
    redirect('/login') unless session[:user_id]

    repo = SpaceRepository.new

    @spaces = repo.find_all('user_id', session[:user_id])

    erb(:my_spaces)
  end

  post '/login' do
    return status 400 unless %i[username password].all? { |param| params.key?(param) }

    repo = UserRepository.new
    user = repo.find('username', params[:username])

    if user
      if params[:password] == user.password
        session.clear
        session[:user_id] = user.id
        redirect '/'
      else
        @error = 'Password incorrect'
        erb(:login)
      end
    else
      @error = 'Username does not exist'
      erb(:login)
    end
  end

  get '/bookings' do
    redirect('/login') unless session[:user_id]

    current_user_id = session[:user_id]

    repo = BookingRepository.new
    @bookings = repo.bookings_with_spaces(current_user_id)

    erb(:bookings)
  end

  get '/owner_bookings' do
    redirect('/login') unless session[:user_id]

    current_user_id = session[:user_id]

    repo = BookingRepository.new
    @owner_bookings = repo.bookings_with_spaces_owner(current_user_id)

    erb(:owner_bookings)
  end

  post '/logout' do
    session.clear
    redirect '/'
  end
end
