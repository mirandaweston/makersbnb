require_relative './app'
require_relative 'lib/database_connection'

DatabaseConnection.connect('makersbnb_test')
run Application
