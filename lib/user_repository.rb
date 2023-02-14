require 'user'

class UserRepository

  def all
    sql_query = 'SELECT id, name, username, email, password FROM users;'
    result_set = DatabaseConnection.exec_params(sql_query, [])

    users = []

    result_set.each do |record|
      user = User.new
      user.id = record['id'].to_i
      user.name = record['name']
      user.username = record['username']
      user.email = record['email']
      user.password = record['password']

      users << user
    end

    return users
  end

  
  def create(user)
    sql_query = 'INSERT INTO users (name, username, email, password) VALUES ($1, $2, $3, $4);'
    params = [user.name, user.username, user.email, user.password]
    DatabaseConnection.exec_params(sql_query, params)
  end
    

  def find(id)
    # Executes the SQL query:
    # SELECT id, name, username, email, password FROM users WHERE id = $1;

    # Returns a single User object.
  end

  # Add more methods below for each operation you'd like to implement.

  def update(user)
    # Executes the SQL query
    # UPDATE user SET id = $1, name = $1, username = $2, email = $3, password = $4;

    # Updates a user
  end

  def delete(user)
    # Executes the SQL query:
    # DELETE FROM users WHERE id = $1;

    # Deletes a user
  end
end