require 'space_repository'

RSpec.describe SpaceRepository do
    
  def reset_spaces_table
    seed_sql = File.read('spec/seeds_bnb.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
    connection.exec(seed_sql)
  end
    
      before(:each) do 
        reset_spaces_table
      end

    it "returns all spaces" do  
      repo = SpaceRepository.new

      spaces = repo.all
      expect(spaces.length).to eq(2)
      expect(spaces.first.id).to eq('1') 
      expect(spaces.first.name).to eq('Paradise Beach')
    end

    it "returns a single space" do
      repo = SpaceRepository.new

      space = repo.find(1)
      expect(space.name).to eq('Paradise Beach')
      expect(space.available).to eq('t')
      expect(space.description).to eq('Seaside getaway')
      expect(space.price).to eq('120')
      expect(space.user_id).to eq('1')
    end
      
    it "creates a new space" do

      repo = SpaceRepository.new

      space = Space.new
      space.name = 'Country Manor'
      space.available = 'f'
      space.description = 'Hilly hikes'
      space.price = '80'
      space.user_id = '2'

      repo.create(space)

      space = repo.all

      last_space = space.last
      expect(last_space.name).to eq('Country Manor')
      expect(last_space.available).to eq('f')
      expect(last_space.description).to eq('Hilly hikes')
      expect(last_space.price).to eq('80')
      expect(last_space.user_id).to eq('2')
    end

    it 'deletes a space' do
      
      repo = SpaceRepository.new

      repo.delete(1)

      spaces = repo.all
      expect(spaces.length).to eq(1)
      expect(spaces.first.id).to eq('2')
    end  
end
