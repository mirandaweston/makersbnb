require_relative 'user'

class UserRepository
  def find(method, value)
    query = <<~SQL
      SELECT * FROM users#{' '}
      WHERE #{method} = $1;
    SQL

    params = [value]

    result_set = DatabaseConnection.exec_params(query, params)

    record = result_set.first

    return if record.nil?

    user = User.new
    user.id = record['id'].to_i
    user.username = record['username']
    user.name = record['name']
    user.email = record['email']
    user.password = record['password']

    user
  end
end
