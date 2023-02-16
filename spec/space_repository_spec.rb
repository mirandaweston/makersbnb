require_relative '../lib/space_repository'

def reset_tables
  seed_sql = File.read('spec/seeds_bnb.sql')
  connection = PG.connect({ host: 'localhost', dbname: 'makersbnb_test' })
  connection.exec(seed_sql)
end

RSpec.describe SpaceRepository do
  before(:each) do
    reset_tables
  end

  it 'returns all spaces' do
    repo = SpaceRepository.new

    spaces = repo.all
    expect(spaces.length).to eq(4)
    expect(spaces.first.id).to eq(1)
    expect(spaces.first.name).to eq('Paradise Beach')
  end

  describe '#find' do
    it 'returns matching record by id' do
      repo = SpaceRepository.new

      expected = have_attributes(
        id: 2,
        name: 'Cityscapes',
        available: true,
        description: 'Bright lights and candlelit bars',
        price: 100,
        user_id: 2
      )

      expect(repo.find('id', 2)).to match(expected)
    end
  end

  it 'returns available spaces' do
    repo = SpaceRepository.new

    spaces = repo.find_all('available', true)

    expect(spaces.all?(&:available)).to be(true)

    expect(spaces.length).to eq 3
  end

  it 'creates a new space' do
    repo = SpaceRepository.new

    space = Space.new
    space.name = 'Country Manor'
    space.available = false
    space.description = 'Hilly hikes'
    space.price = 80
    space.user_id = 2

    repo.create(space)

    space = repo.all

    last_space = space.last
    expect(last_space.name).to eq('Country Manor')
    expect(last_space.available).to eq(false)
    expect(last_space.description).to eq('Hilly hikes')
    expect(last_space.price).to eq(80)
    expect(last_space.user_id).to eq(2)
  end

  it 'deletes a space' do
    repo = SpaceRepository.new

    repo.delete(1)

    spaces = repo.all
    expect(spaces.length).to eq(3)
    expect(spaces.first.id).to eq(2)
  end

  it 'updates a space' do
    repo = SpaceRepository.new

    space = repo.find('id', 1)

    repo.update(space, 'available', false)

    updated_request = repo.find('id', 1)
    expect(updated_request.available).to eq false
  end

  it 'finds all spaces based on user id' do
    repo = SpaceRepository.new
    spaces = repo.find_all('user_id', 2)

    expect(spaces.length).to eq(3)
    expect(spaces[0].id).to eq(2)
    expect(spaces[0].name).to eq('Cityscapes')

    expect(spaces[1].id).to eq(3)
    expect(spaces[1].name).to eq('Countryside Lodge')
  end

  it 'finds all spaces based on availability' do
    repo = SpaceRepository.new
    spaces = repo.find_all('available', true)

    expect(spaces.length).to eq(3)
    expect(spaces[0].id).to eq(1)
    expect(spaces[0].name).to eq('Paradise Beach')

    expect(spaces[1].id).to eq(2)
    expect(spaces[1].name).to eq('Cityscapes')

    expect(spaces[2].id).to eq(4)
    expect(spaces[2].name).to eq('Seaside Spa')
  end
end
