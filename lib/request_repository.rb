require_relative '../lib/space'
require_relative '../lib/request'

class RequestRepository
    def all
        sql = 'SELECT id, date_of_request, approved, user_id, space_id FROM requests;'
        results = DatabaseConnection.exec_params(sql, [])

        requests = []

        results.each do |record|
            request = Request.new
            request.id = record['id']
            request.date_of_request = record['date_of_request']
            request.approved = record['approved']
            request.user_id = record['user_id']
            request.space_id = record['space_id']

            requests << request
        end
        return requests
    end

    def find(method, value)
        sql = <<~SQL
        SELECT * FROM requests#{' '}
        WHERE #{method} = $1;
        SQL

        #sql = 'SELECT * FROM requests WHERE #{method} = $1;'
        params = [value]
        results = DatabaseConnection.exec_params(sql, params) 

        requests = []

        results.each do |record|
            request = Request.new
            request.id = record['id']
            request.date_of_request = record['date_of_request']
            request.approved = record['approved']
            request.user_id = record['user_id']
            request.space_id = record['space_id']

            requests << request
        end

        return requests
    end

    def create(request)
      sql_query = 'INSERT INTO requests (date_of_request, approved, user_id, space_id) VALUES ($1, $2, $3, $4);'
      params = [request.date_of_request, request.approved, request.user_id, request.space_id]
      DatabaseConnection.exec_params(sql_query, params)
    end

    def update(request, method, value)
        sql = <<~SQL
        UPDATE requests#{' '}
        SET #{method} = $1
        WHERE id = #{request.id};
        SQL

        params = [value]
        DatabaseConnection.exec_params(sql, params)

        if method == 'approved'
          repo = SpaceRepository.new
          space = repo.find(request.space_id)
          repo.update(space,'available','f')
        end
    end

    # def delete()

    # end
end