require_relative '../lib/space'
require_relative '../lib/booking'
require_relative '../lib/booking_with_space'

class BookingRepository
  def all
    query = <<~SQL
      SELECT id, date_of_booking, approved, user_id, space_id
      FROM bookings;
    SQL

    results = DatabaseConnection.exec_params(query, [])

    results.map { |record| record_to_booking(record) }
  end

  def find_all(method, value)
    query = <<~SQL
      SELECT * FROM bookings
      WHERE #{method} = $1;
    SQL

    params = [value]
    results = DatabaseConnection.exec_params(query, params)

    results.map { |record| record_to_booking(record) }
  end

  def create(booking)
    query = <<~SQL
      INSERT INTO bookings (date_of_booking, approved, user_id, space_id)
      VALUES ($1, $2, $3, $4);
    SQL

    params = [booking.date_of_booking, booking.approved, booking.user_id, booking.space_id]
    DatabaseConnection.exec_params(query, params)
  end

  def update(booking, method, value)
    query = <<~SQL
      UPDATE bookings
      SET #{method} = $1
      WHERE id = $2;
    SQL

    params = [value, booking.id]
    DatabaseConnection.exec_params(query, params)

    return unless method == 'approved'

    repo = SpaceRepository.new
    space = repo.find('id', booking.space_id)
    repo.update(space, 'available', false)
  end

  private

  def record_to_booking(record)
    booking = Booking.new
    booking.id = record['id'].to_i
    booking.date_of_booking = Date.parse(record['date_of_booking'])
    booking.approved = value_to_boolean(record['approved'])
    booking.user_id = record['user_id'].to_i
    booking.space_id = record['space_id'].to_i
    booking
  end

  def value_to_boolean(value)
    value.eql?('t') ? true : false
  end

  def bookings_with_spaces(session_id)
    sql_query = 'SELECT bookings.id, bookings.date_of_booking, bookings.approved, bookings.user_id, bookings.space_id AS space_id, spaces.name FROM bookings JOIN spaces ON spaces.id = bookings.space_id WHERE bookings.user_id = $1;'
    params = [session_id]
    bookings_spaces_joined = DatabaseConnection.exec_params(sql_query, params)

    bookings = []

    bookings_spaces_joined.each do |record|
      booking = BookingWithSpace.new
      booking.id = record['id']
      booking.date_of_booking = record['date_of_booking']
      booking.approved = record['approved']
      booking.user_id = record['user_id']
      booking.space_id = record['space_id']
      booking.name = record['name']

      bookings << booking
    end

    return bookings
  end
end