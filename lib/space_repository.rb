require_relative 'space'
require_relative 'database_connection'

class SpaceRepository
  def all
    sql = 'SELECT id, name, available, description, price, user_id FROM spaces;'
    result_set = DatabaseConnection.exec_params(sql, [])
    spaces = []

    result_set.each do |record|
      space = Space.new
      space.id = record['id']
      space.name = record['name']
      space.available = record['available']
      space.description = record['description']
      space.price = record['price']
      space.user_id = record['user_id']

      spaces << space
    end
    spaces
  end

  def find(method, value)
    query = <<~SQL
      SELECT * FROM spaces#{' '}
      WHERE #{method} = $1;
    SQL

    params = [value]

    result_set = DatabaseConnection.exec_params(query, params)

    record = result_set.first

    return if record.nil?

    space = Space.new
    space.id = record['id'].to_i
    space.name = record['name']
    space.available = record['available']
    space.description = record['description']
    space.price = record['price']
    space.user_id = record['user_id']
    
    return space
  end

  def find_available
    sql = 'SELECT id, name, available, description, price, user_id FROM spaces WHERE available = TRUE;'
    result_set = DatabaseConnection.exec_params(sql, [])

    available_spaces = []

    result_set.each do |record|
      space = Space.new
      space.id = record['id']
      space.name = record['name']
      space.available = record['available']
      space.description = record['description']
      space.price = record['price']
      space.user_id = record['user_id']
  
      available_spaces << space
    end
    return available_spaces
  end

  def create(space)
    sql = 'INSERT INTO spaces (name, available, description, price, user_id) VALUES ($1, $2, $3, $4, $5);'
    sql_params = [space.name, space.available, space.description, space.price, space.user_id]
    DatabaseConnection.exec_params(sql, sql_params)
  end

  def delete(id)
    sql = 'DELETE FROM spaces WHERE id=$1;'
    sql_params = [id]
    DatabaseConnection.exec_params(sql, sql_params)
  end

  def update(space, method, value)
    sql = <<~SQL
    UPDATE spaces#{' '}
    SET #{method} = $1
    WHERE id = #{space.id};
    SQL

    params = [value]
    DatabaseConnection.exec_params(sql, params)
  end
end

  def find_all(column, value)
    query = <<~SQL
      SELECT * FROM spaces
      WHERE #{column} = $1;
    SQL

    params = [value]

    result_set = DatabaseConnection.exec_params(query, params)

    spaces = []

    result_set.each do |record|
      space = Space.new
      space.id = record['id']
      space.name = record['name']
      space.available = record['available']
      space.description = record['description']
      space.price = record['price']
      space.user_id = record['user_id']

      spaces << space
    end
    spaces
  end
end

