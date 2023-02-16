require_relative 'space'
require_relative 'database_connection'

class SpaceRepository
  def all
    query = <<~SQL
      SELECT id, name, available, description, price, user_id
      FROM spaces;
    SQL

    result_set = DatabaseConnection.exec_params(query, [])

    result_set.map { |record| record_to_space(record) }
  end

  def find(method, value)
    query = <<~SQL
      SELECT * FROM spaces
      WHERE #{method} = $1;
    SQL

    params = [value]

    result_set = DatabaseConnection.exec_params(query, params)

    record = result_set.first

    return if record.nil?

    record_to_space(record)
  end

  def create(space)
    query = <<~SQL
      INSERT INTO spaces (name, available, description, price, user_id)
      VALUES ($1, $2, $3, $4, $5);
    SQL

    params = [space.name, space.available, space.description, space.price, space.user_id]
    DatabaseConnection.exec_params(query, params)
  end

  def delete(id)
    query = <<~SQL
      DELETE FROM spaces
      WHERE id = $1;
    SQL

    params = [id]
    DatabaseConnection.exec_params(query, params)
  end

  def update(space, method, value)
    query = <<~SQL
      UPDATE spaces
      SET #{method} = $1
      WHERE id = $2;
    SQL

    params = [value, space.id]
    DatabaseConnection.exec_params(query, params)
  end

  def find_all(column, value)
    query = <<~SQL
      SELECT * FROM spaces
      WHERE #{column} = $1;
    SQL

    params = [value]

    result_set = DatabaseConnection.exec_params(query, params)

    result_set.map { |record| record_to_space(record) }
  end

  private

  def record_to_space(record)
    space = Space.new
    space.id = record['id'].to_i
    space.name = record['name']
    space.available = value_to_boolean(record['available'])
    space.description = record['description']
    space.price = record['price'].to_i
    space.user_id = record['user_id'].to_i
    space
  end

  def value_to_boolean(value)
    value.eql?('t') ? true : false
  end
end
