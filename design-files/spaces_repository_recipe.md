# Spaces Model and Repository Classes Design Recipe

_Copy this recipe template to design and implement Model and Repository classes for a database table._

## 1. Design and create the Table

If the table is already created in the database, you can skip this step.

Otherwise, [follow this recipe to design and create the SQL schema for your table](./single_table_design_recipe_template.md).

*Already created

## 2. Create Test SQL seeds

Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

```sql
Seed data already provided
```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 your_database_name < seeds_{table_name}.sql
```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby

# Model class
# (in lib/space.rb)
class Space
end

# Repository class
# (in lib/space_repository.rb)
class SpaceRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby

# Table name: spaces

# Model class
# (in lib/space.rb)

class Space
  attr_accessor :id, :name, :description, :price, :user_id
end


```

*You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.*

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby

# Table name: spaces

# Repository class
# (in lib/space_repository.rb)

class SpaceRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, name, description, price, user_id FROM spaces;

    # Returns an array of Space objects.
  end

  def find(id)
    #Executes SQL query
    #SELECT id, name, description, price, user_id FROM spaces WHERE id = $1;
  end

  def create(space)
  # INSERT INTO spaces (name, description, price, user_id) VALUES ($1, $2, $3, $4);

  # Not return anything, just creates
  end

  def delete(id)
    #DELETE FROM spaces WHERE id=$1;

    #returns nothing
  end

  def find_all(column, value)
    #Executes SQL query
    #SELECT * FROM spaces WHERE #{column} = $1;
  end

end
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES

# 1
# Get all spaces

repo = SpaceRepository.new

spaces = repo.all
spaces.length # => 2
spaces.first.id # => '1'
spaces.first.name # => 'Paradise Beach'

# 2
# Get a single space

repo = SpaceRepository.new

space = repo.find(1)
space.name # => 'Paradise Beach'
space.available # => true
space.description # => 'Seaside getaway'
space.price # => '120'
space.user_id # => '1'

# 3
# Creates a new space

repo = SpaceRepository.new

space = Space.new
space.name = 'Country Manor'
space.description = 'Hilly hikes'
space.price = '80'
space.user_id = '2'

repo.create(space) # => nil

space = repo.all

last_space = space.last
last_space.name # => 'Country Manor'
last_space.description # => 'Hilly hikes'
last_space.price # => '80'
last_space.user_id # => '2'

# 4
# Deletes a space

repo = SpaceRepository.new

repo.delete(1)

spaces = repo.all
spaces.length # => 1
spaces.first.id # => 2

# 5
# Finds all spaces based on user id

repo = SpaceRepository.new
spaces = repo.find_all('user_id',2)

expect(spaces.length).to eq(3)
expect(spaces[0].id).to eq('2') 
expect(spaces[0].name).to eq('Cityscapes')

expect(spaces[1].id).to eq('3') 
expect(spaces[1].name).to eq('Countryside Lodge')

# 6
# Finds all spaces based on availability

repo = SpaceRepository.new
spaces = repo.find_all('available',true)

expect(spaces.length).to eq(3)
expect(spaces[0].id).to eq('1') 
expect(spaces[0].name).to eq('Paradise Beach')

expect(spaces[1].id).to eq('2') 
expect(spaces[1].name).to eq('Cityscapes')

expect(spaces[2].id).to eq('4') 
expect(spaces[2].name).to eq('Seaside Spa')

```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/space_repository_spec.rb

def reset_tables
  seed_sql = File.read('spec/seeds_bnb.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
  connection.exec(seed_sql)
end

describe SpaceRepository do
  before(:each) do 
    reset_tables
  end

  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._

