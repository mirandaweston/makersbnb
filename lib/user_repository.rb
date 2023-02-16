require_relative 'user'

class UserRepository
  def all
    query = <<~SQL
      SELECT id, name, username, email, password
      FROM users;
    SQL

    result_set = DatabaseConnection.exec_params(query, [])

    result_set.map { |record| record_to_user(record) }
  end

  def create(user)
    query = <<~SQL
      INSERT INTO users (name, username, email, password)
      VALUES ($1, $2, $3, $4);
    SQL
    params = [user.name, user.username, user.email, user.password]
    DatabaseConnection.exec_params(query, params)
  end

  def find(column, value)
    query = <<~SQL
      SELECT * FROM users
      WHERE #{column} = $1;
    SQL

    params = [value]

    result_set = DatabaseConnection.exec_params(query, params)

    record = result_set.first

    return if record.nil?

    record_to_user(record)
  end

  def delete(id)
    query = <<~SQL
      DELETE FROM users
      WHERE id = $1;
    SQL

    DatabaseConnection.exec_params(query, [id])
  end

  def update(user)
    query = <<~SQL
      UPDATE users SET name = $1, username = $2, email = $3, password = $4
      WHERE id = $5;
    SQL
    params = [user.name, user.username, user.email, user.password, user.id]
    DatabaseConnection.exec_params(query, params)
  end

  private

  def record_to_user(record)
    user = User.new
    user.id = record['id'].to_i
    user.username = record['username']
    user.name = record['name']
    user.email = record['email']
    user.password = record['password']
    user
  end
end
