require_relative '../lib/space'
require_relative '../lib/request'

class RequestRepository
  def all
    query = <<~SQL
      SELECT id, date_of_request, approved, user_id, space_id
      FROM requests;
    SQL

    results = DatabaseConnection.exec_params(query, [])

    results.map { |record| record_to_request(record) }
  end

  def find_all(method, value)
    query = <<~SQL
      SELECT * FROM requests
      WHERE #{method} = $1;
    SQL

    params = [value]
    results = DatabaseConnection.exec_params(query, params)

    results.map { |record| record_to_request(record) }
  end

  def create(request)
    query = <<~SQL
      INSERT INTO requests (date_of_request, approved, user_id, space_id)
      VALUES ($1, $2, $3, $4);
    SQL

    params = [request.date_of_request, request.approved, request.user_id, request.space_id]
    DatabaseConnection.exec_params(query, params)
  end

  def update(request, method, value)
    query = <<~SQL
      UPDATE requests
      SET #{method} = $1
      WHERE id = $2;
    SQL

    params = [value, request.id]
    DatabaseConnection.exec_params(query, params)

    return unless method == 'approved'

    repo = SpaceRepository.new
    space = repo.find('id', request.space_id)
    repo.update(space, 'available', false)
  end

  private

  def record_to_request(record)
    request = Request.new
    request.id = record['id'].to_i
    request.date_of_request = Date.parse(record['date_of_request'])
    request.approved = value_to_boolean(record['approved'])
    request.user_id = record['user_id'].to_i
    request.space_id = record['space_id'].to_i
    request
  end

  def value_to_boolean(value)
    value.eql?('t') ? true : false
  end
end
