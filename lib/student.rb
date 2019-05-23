class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new = self.new
    new.id = row[0]
    new.name = row[1]
    new.grade = row[2]
    new

  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students
    SQL

      DB[:conn].execute(sql).map {|row| new_from_db(row)}
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students WHERE "name" = ?
    SQL

    self.new_from_db(*DB[:conn].execute(sql, name))
  end

  def self.all_students_in_grade_9
    sql = <<-SQL
      SELECT * FROM students WHERE "grade" = 9
    SQL

    DB[:conn].execute(sql).map {|row| new_from_db(row)}
  end

  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
      SELECT * FROM students WHERE "grade" = 10 LIMIT ?
    SQL

    DB[:conn].execute(sql, x).map {|row| new_from_db(row)}
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * FROM students WHERE "grade" = 10 LIMIT 1
    SQL

    new_from_db(*DB[:conn].execute(sql))
  end

  def self.all_students_in_grade_X(x)
    sql = <<-SQL
      SELECT * FROM students WHERE "grade" = ?
    SQL

    DB[:conn].execute(sql, x).map {|row| new_from_db(row)}
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students WHERE "grade" < 12
    SQL

    DB[:conn].execute(sql).map {|row| new_from_db(row)}
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT id FROM students")[0][0]
    self
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
