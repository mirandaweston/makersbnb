require_relative 'app'
require_relative 'lib/database_connection'

DatabaseConnection.connect('makersbnb')
run Application
