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
    sql_query = 'SELECT id, name, username, email, password FROM users WHERE id = $1;'
    result_set = DatabaseConnection.exec_params(sql_query, [id])

    first_record = result_set.first

    user = User.new
    user.id = first_record['id'].to_i
    user.name = first_record['name']
    user.username = first_record['username']
    user.email = first_record['email']
    user.password = first_record['password']

    return user
  end

  

  def delete(id)
    sql_query = 'DELETE FROM users WHERE id = $1;'
    DatabaseConnection.exec_params(sql_query,[id])
  end

  def update(user)
    sql_query = 'UPDATE users SET name = $1, username = $2, email = $3, password = $4 WHERE id = $5;'
    params = [user.name, user.username, user.email, user.password, user.id]
    DatabaseConnection.exec_params(sql_query,params)

    return nil
  end
end
