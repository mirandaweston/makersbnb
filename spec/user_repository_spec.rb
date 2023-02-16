require_relative '../lib/user_repository'

def reset_tables
  seeds_sql = File.read('spec/seeds_bnb.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
  connection.exec(seeds_sql)
end

RSpec.describe UserRepository do
  before(:each) do
    reset_tables
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
    expect(users[1].username).to eq 'junio'
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

  describe '#find' do
    it 'returns matching record by id' do
      repo = UserRepository.new

      expected = have_attributes(
        id: 2,
        email: 'junaid@makers.com',
        password: 'password2',
        name: 'Junaid',
        username: 'junio'
      )

      expect(repo.find('id', 2)).to match(expected)
    end

    it 'returns matching record by username' do
      repo = UserRepository.new

      expected = have_attributes(
        id: 2,
        email: 'junaid@makers.com',
        password: 'password2',
        name: 'Junaid',
        username: 'junio'
      )

      expect(repo.find('username', 'junio')).to match(expected)
    end

    it 'returns matching record by email' do
      repo = UserRepository.new

      expected = have_attributes(
        id: 2,
        email: 'junaid@makers.com',
        password: 'password2',
        name: 'Junaid',
        username: 'junio'
      )

      expect(repo.find('email', 'junaid@makers.com')).to match(expected)
    end
  end

  it 'deletes a user' do
    user_repo = UserRepository.new
    user = user_repo.find('id', 1)

    user_repo.delete(user.id)

    expect(user_repo.all.length).to eq 1
    expect(user_repo.all.first.id).to eq 2
  end

  it 'updates a user' do
    user_repo = UserRepository.new
    user = user_repo.find('id', 1)

    user.name = 'Joel_2'
    user.username = 'joelio_2'
    user.email = 'joel@makers.com_2'
    user.password = 'password1_2'

    user_repo.update(user)

    updated_user = user_repo.find('id', 1)

    # expect(updated_user.id).to eq 1
    expect(updated_user.name).to eq 'Joel_2'
    expect(updated_user.username).to eq 'joelio_2'
    expect(updated_user.email).to eq 'joel@makers.com_2'
    expect(updated_user.password).to eq 'password1_2'
  end
end
