require_relative './space'
require 'database_connection'

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
    return spaces
  end  

  def find(id)
    sql = 'SELECT id, name, available, description, price, user_id FROM spaces WHERE id = $1;'
    sql_params = [id]
    result_set = DatabaseConnection.exec_params(sql, sql_params)

    record = result_set[0]
    space = Space.new
    space.id = record['id']
    space.name = record['name']
    space.available = record['available']
    space.description = record['description']
    space.price = record['price']
    space.user_id = record['user_id']

    return space
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
end