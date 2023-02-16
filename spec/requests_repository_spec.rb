require 'space_repository'
require 'request_repository'

RSpec.describe RequestRepository do
    
  def reset_tables
    seed_sql = File.read('spec/seeds_bnb.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
    connection.exec(seed_sql)
  end
    
    before(:each) do 
      reset_tables
    end
  
  it "lists the number of requests that exist" do
    repo = RequestRepository.new

    requests = repo.all

    expect(requests.length).to eq 2
  end

  it "finds the first request for current user" do
    repo = RequestRepository.new

    requests = repo.find('user_id', 1)

    expect(requests.first.user_id).to eq '1'
    expect(requests.first.date_of_request).to eq('2023-02-13')
    expect(requests.first.approved).to eq 't'
    expect(requests.first.space_id).to eq '2'
  end

  it "creates a new request" do
    repo = RequestRepository.new
    request = Request.new

    request.date_of_request = '2023-12-25'
    request.approved = 't'
    request.user_id = '2'
    request.space_id = '2'

    repo.create(request)
    
    expect(repo.all.length).to eq 3
    expect(repo.all.last.date_of_request).to eq '2023-12-25'
  end

  it "updates a request" do
    repo = RequestRepository.new
    request = repo.find('id',2).first

    repo.update(request,'approved','f')
    
    updated_request = repo.find('id',2)
    expect(updated_request.last.approved).to eq 'f'
  end

  it "Approves a space and changes availability to F in spaces table" do
    request_repo = RequestRepository.new
    request = request_repo.find('id',2).first

    request_repo.update(request,'approved','t')

    spaces_repo = SpaceRepository.new
    space = spaces_repo.find(request.space_id)
    
    updated_request = request_repo.find('id',2)
    expect(updated_request.last.approved).to eq 't'
    expect(space.available).to eq 'f'
  end
end
