require_relative '../lib/space_repository'
require_relative '../lib/booking_repository'

def reset_tables
  seed_sql = File.read('spec/seeds_bnb.sql')
  connection = PG.connect({ host: 'localhost', dbname: 'makersbnb_test' })
  connection.exec(seed_sql)
end

RSpec.describe BookingRepository do
  before(:each) do
    reset_tables
  end

  it 'lists the number of bookings that exist' do
    repo = BookingRepository.new

    bookings = repo.all

    expect(bookings.length).to eq 2
  end

  it 'finds the first booking for current user' do
    repo = BookingRepository.new

    bookings = repo.find_all('user_id', 1)

    expect(bookings.first.user_id).to eq 1
    expect(bookings.first.date_of_booking).to eq(Date.new(2023, 0o2, 13))
    expect(bookings.first.approved).to eq true
    expect(bookings.first.space_id).to eq 2
  end

  it 'creates a new booking' do
    repo = BookingRepository.new
    booking = Booking.new

    booking.date_of_booking = '2023-12-25'
    booking.approved = true
    booking.user_id = 2
    booking.space_id = 2

    repo.create(booking)

    expect(repo.all.length).to eq 3
    expect(repo.all.last.date_of_booking).to eq Date.new(2023, 12, 25)
  end

  it 'updates a booking' do
    repo = BookingRepository.new
    booking = repo.find_all('id', 2).first

    repo.update(booking, 'approved', false)

    updated_booking = repo.find_all('id', 2)
    expect(updated_booking.last.approved).to eq false
  end

  it 'Approves a space and changes availability to F in spaces table' do
    booking_repo = BookingRepository.new
    booking = booking_repo.find_all('id', 2).first

    booking_repo.update(booking, 'approved', true)

    updated_booking = booking_repo.find_all('id', 2)
    expect(updated_booking.last.approved).to eq true

    spaces_repo = SpaceRepository.new
    space = spaces_repo.find('id', booking.space_id)
    expect(space.available).to eq false
  end

  it 'returns bookings and spaces requested by a user' do
    booking_repo = BookingRepository.new
    
    result = booking_repo.bookings_with_spaces('1')
    expect(result.length).to eq 1
    expect(result.first.name).to eq "Cityscapes"
  end

  it 'returns bookings and spaces for an owner' do
    booking_repo = BookingRepository.new
    
    result = booking_repo.bookings_with_spaces_owner('2')
    expect(result.length).to eq 1
    expect(result.first.name).to eq "Cityscapes"
  end
end
