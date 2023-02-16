require_relative '../lib/space_repository'
require_relative '../lib/request_repository'

def reset_tables
  seed_sql = File.read('spec/seeds_bnb.sql')
  connection = PG.connect({ host: 'localhost', dbname: 'makersbnb_test' })
  connection.exec(seed_sql)
end

RSpec.describe RequestRepository do
  before(:each) do
    reset_tables
  end

  it 'lists the number of requests that exist' do
    repo = RequestRepository.new

    requests = repo.all

    expect(requests.length).to eq 2
  end

  it 'finds the first request for current user' do
    repo = RequestRepository.new

    requests = repo.find_all('user_id', 1)

    expect(requests.first.user_id).to eq 1
    expect(requests.first.date_of_request).to eq(Date.new(2023, 0o2, 13))
    expect(requests.first.approved).to eq true
    expect(requests.first.space_id).to eq 2
  end

  it 'creates a new request' do
    repo = RequestRepository.new
    request = Request.new

    request.date_of_request = '2023-12-25'
    request.approved = true
    request.user_id = 2
    request.space_id = 2

    repo.create(request)

    expect(repo.all.length).to eq 3
    expect(repo.all.last.date_of_request).to eq Date.new(2023, 12, 25)
  end

  it 'updates a request' do
    repo = RequestRepository.new
    request = repo.find_all('id', 2).first

    repo.update(request, 'approved', false)

    updated_request = repo.find_all('id', 2)
    expect(updated_request.last.approved).to eq false
  end

  it 'Approves a space and changes availability to F in spaces table' do
    request_repo = RequestRepository.new
    request = request_repo.find_all('id', 2).first

    request_repo.update(request, 'approved', true)

    updated_request = request_repo.find_all('id', 2)
    expect(updated_request.last.approved).to eq true

    spaces_repo = SpaceRepository.new
    space = spaces_repo.find('id', request.space_id)
    expect(space.available).to eq false
  end
end
