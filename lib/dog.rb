class Dog 
  
  attr_accessor :name, :breed
  attr_reader :id
  
  def intialize(name:, breed:, id: nil)
    @name = name
    @breed = breed 
    @id = id
  end
  
end