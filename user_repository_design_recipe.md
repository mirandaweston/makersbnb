# {{Users}} Model and Repository Classes Design Recipe

_Copy this recipe template to design and implement Model and Repository classes for a database table._

## 1. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
# EXAMPLE
# Table name: users

# Model class
# (in lib/user.rb)
class User
  
end

# Repository class
# (in lib/user_repository.rb)
class UserRepository
  
end
```

## 2. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# EXAMPLE
# Table name: users

# Model class
# (in lib/user.rb)

class User
  attr_accessor: :id, :name, :username, :email, :password
end

```

*You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.*

## 3. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# EXAMPLE
# Table name: users

# Repository class
# (in lib/user_repository.rb)

class UserRepository

  def create(user)
    # Executes the SQL query:
    # INSERT INTO users (name, username, email, password) VALUES ($1, $2, $3, $4);

    # Create a new user
  end
  
  def all
    # Executes the SQL query:
    # SELECT id, name, username, email, password FROM users;

    # Returns an array of User objects.
  end

  # Gets a single record by its ID
  # One argument: the id (number)
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
```

## 4. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES

# 1
# Get all users

repo = UserRepository.new

users = repo.all

users.length # =>  2

users[0].id # =>  1
users[0].name # =>  'Joel'
users[0].username # =>  'joelio'
users[0].password # => 'password1'

users[1].id # =>  2
users[1].name # =>  'Junaid'
users[1].username # =>  'Junio'
users[1].password # => 'password2'

# 2
# Get a single user

repo = UserRepository.new

user = repo.find(1)

user.id # =>  1
user.name # =>  'Joel'
user.username # => 'joelio'
user.password # => 'password1'

# 3
# Create a new user

user_repo = UserRepository.new
user = User.new
user.name # => 'Jerome'
user.username # => 'joromeo'
user.email # => 'jerome@makers.com'
user.password # => 'password3'

user_repo.create(user)

# 4
# Delete a user

user_repo = UserRepository.new
user = user_repo.find(1)

user_repo.delete(user.id)

user_repo.all # => 1
user_repo.all.first.id # => 2

# 5
# Update a user

user_repo = UserRepository.new
user = user_repo.find(1)

user.name # =>  'Joel_2'
user.username # => 'joelio_2'
user.password # => 'password1_2'

user_repo.update(user)

updated_user = user_repo.find(1)
updated_user.name # => 'Joel_2'
updated_user.username # => 'joelio_2'
updated_user.password # => 'password1_2'

# Add more examples for each method
```

Encode this example as a test.

## 5. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/user_repository_spec.rb

def reset_users_table
  seeds_sql = File.read('spec/seeds_bnb.sql')
  connection = PG.connect({host: '27.0.0.1', dbname: 'makersbnb_test_database'})
  connection.exec(seeds_sql)
end

before(:each) do
  reset_users_table
end


```

## 6. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._

<!-- BEGIN GENERATED SECTION DO NOT EDIT -->

---

**How was this resource?**  
[😫](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Frepository_class_recipe_template.md&prefill_Sentiment=😫) [😕](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Frepository_class_recipe_template.md&prefill_Sentiment=😕) [😐](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Frepository_class_recipe_template.md&prefill_Sentiment=😐) [🙂](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Frepository_class_recipe_template.md&prefill_Sentiment=🙂) [😀](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Frepository_class_recipe_template.md&prefill_Sentiment=😀)  
Click an emoji to tell us.

<!-- END GENERATED SECTION DO NOT EDIT -->