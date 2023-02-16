require_relative '../lib/space'
require_relative '../lib/booking'

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
end
