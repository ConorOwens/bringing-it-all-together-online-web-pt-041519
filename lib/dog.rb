class Dog 
  
  attr_accessor :name, :breed, :id
  
  def initialize(info)
    info.each {|key, value| self.send(("#{key}="), value)}
    self.id ||= nil
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
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
      self
    end
  end
  
  def self.create(hash)
    dog = Dog.new(hash)
    dog.save
  end
  
  def update
    DB[:conn].execute("UPDATE dogs SET name = ?, breed = ?, id = ?", self.name, self.breed, self.id)
  end
  
  def self.find_by_id(id)
    DB[:conn].execute("SELECT * FROM dogs WHERE id = ?", id).map do |row|
      Dog.new_from_db(row)
    end.first 
  end
  
  def self.new_from_db(row)
    self.new(id: row[0], name: row[1], breed: row[2])
  end
  
  def self.find_or_create_by(name:, breed:)
    dog = DB[:conn].execute("SELECT * FROM dogs WHERE name = ? AND breed = ?", name, breed).first
    if dog
      dogger = self.new_from_db(dog)
    else
      dogger = self.create({name: name, breed: breed})
    end
    dogger
  end 
  
  def self.find_by_name(name)
    dog = DB[:conn].execute("SELECT * FROM dogs WHERE name = ?", name).first
    Dog.new_from_db(dog)
  end
  
end