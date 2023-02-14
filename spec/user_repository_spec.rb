require_relative '../lib/user'
require_relative '../lib/user_repository'

def reset_tables
  seed_sql = File.read('spec/seeds_bnb.sql')
  connection = PG.connect({ host: 'localhost', dbname: 'makersbnb_test' })
  connection.exec(seed_sql)
end

describe UserRepository do
  before(:each) do
    reset_tables
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
end
