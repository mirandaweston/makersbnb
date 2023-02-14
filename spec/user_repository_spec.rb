require 'user_repository'
require 'database_connection'

def reset_users_table
  seeds_sql = File.read('spec/seeds_bnb.sql')
  connection = PG.connect({host: '127.0.0.1', dbname: 'makersbnb_test'})
  connection.exec(seeds_sql)
end

RSpec.describe UserRepository do
  before(:each) do
    reset_users_table
  end

  it 'returns a list of users' do
    repo = UserRepository.new
    users = repo.all

    expect(users.length).to eq 2
    expect(users[0].id).to eq 1
    expect(users[0].name).to eq 'Joel'
    expect(users[0].username).to eq 'joelio'
    expect(users[0].password).to eq 'password1'

    expect(users[1].id).to eq 2
    expect(users[1].name).to eq 'Junaid'
    expect(users[1].username).to eq 'Junio'
    expect(users[1].password).to eq 'password2'
  end
    
  it 'creates a new user' do
    user_repo = UserRepository.new
    user = User.new
    user.name = 'Jerome'
    user.username = 'joromeo'
    user.email = 'jerome@makers.com'
    user.password = 'password3'

    user_repo.create(user)
    
    expect(user_repo.all.length).to eq 3
    expect(user_repo.all.last.name).to eq 'Jerome'
  end

  it 'finds a single user' do
    repo = UserRepository.new
    user = repo.find(1)

    expect(user.id).to eq 1
    expect(user.name).to eq 'Joel'
    expect(user.username).to eq 'joelio'
    expect(user.password).to eq 'password1'
  end

  it 'deletes a user' do
    user_repo = UserRepository.new
    user = user_repo.find(1)

    user_repo.delete(user.id)

    expect(user_repo.all.length).to eq 1
    expect(user_repo.all.first.id).to eq 2
  end

  it 'updates a user' do
    user_repo = UserRepository.new
    user = user_repo.find(1)

    user.name = 'Joel_2'
    user.username = 'joelio_2'
    user.email = 'joel@makers.com_2'
    user.password = 'password1_2'

    user_repo.update(user)

    updated_user = user_repo.find(1)
    # expect(updated_user.id).to eq 1
    expect(updated_user.name).to eq 'Joel_2'
    expect(updated_user.username).to eq 'joelio_2'
    expect(updated_user.email).to eq 'joel@makers.com_2'
    expect(updated_user.password).to eq 'password1_2'
  end
end
