require_relative "../config/environment.rb"

class Student

  attr_accessor :name, :grade, :id


  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students(
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER
    )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def save
    if self.id
      self.update
    else
    sql = <<-SQL
    INSERT INTO students(
      name, grade
    )
    VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end
end

def self.create(name, grade)
  new_student = Student.new(name, grade)
  new_student.save
end

def update
  sql = <<-SQL
  UPDATE students
  SET name = ?, grade = ?
  WHERE id = ?
  SQL
  DB[:conn].execute(sql, self.name, self.grade, self.id)
end

def self.new_from_db(array)
  new_instance = self.new(array[1], array[2], array[0])
  new_instance
end

def self.find_by_name(name)
  sql = <<-SQL
  SELECT*
  FROM students
  WHERE name = ?
  SQL
  result = DB[:conn].execute(sql, name)
  self.new_from_db(result[0])
end




end
