class Dog 
  
  attr_accessor :name, :breed
  attr_reader :id
  
  def initialize(name:, breed:, id: nil)
    @name = name
    @breed = breed 
    @id = id
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE dogs (
      id INTEGER PRIMARY KEY,
      name TEXT,
      breed TEXT
      );
      SQL
    DB[:conn].execute(sql)
  end
  
  def self.drop_table
    DB[:conn].execute("DROP TABLE IF EXISTS dogs")
  end
  
  def save
    if self.id
      self.update
    else
      DB[:conn].execute("INSERT INTO dogs (name, breed) VALUES (?, ?)", self.name, self.breed)
    end
  end
  
  def create(hash)
    arr = []
    hash.each {|key, value| arr << value}
    dog = Dog.new(arr)
    dog.save
    dog
  end
  
  def update
    DB[:conn].execute("UPDATE dogs SET name = ?, breed = ?, id = ?", self.name, self.breed, self.id)
  end
  
end