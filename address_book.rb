require "./employee"
require "yaml"

class AddressBook
  attr_reader :employees

  def initialize
    @employees = []
    open()
  end

  def open
    if File.exist?("yaml/employees.yml")
      @employees = YAML.load_file("yaml/employees.yml",
        permitted_classes: [Employee, PhoneNumber, Address])
    end
  end

  def save
    File.open("yaml/employees.yml", "w") do |file|
      file.write(employees.to_yaml)
    end
  end

  # Main menu logic
  def run 
    puts "\n"
    loop do
      puts "### HUMAN RESOURCES MAIN MENU ###"
      puts "\n"
      puts "    a:  Add Employee"
      puts "    p:  Print all employees"
      puts "    s:  Search"
      puts "    b:  Birthday list for the current month"
      puts "    c:  Clear the screen"
      puts "\n"
      puts "    e:  Exit"
      puts "\n"
      print "Enter your choice: "
      input = gets.chomp.downcase
      case input
      when 'a'
        add_employee
      when 'p'
        print_employee_list
      when 's'
        print "Search term: "
        search = gets.chomp
        find_by_birth_month(search)
        find_by_name(search)
      when 'b'
        puts "\e[H\e[2J"
        time = Time.new()
        month_name = time.strftime("%B")
        find_by_birth_month(month_name)
      when 'c'
        puts "\e[H\e[2J"
      when 'e'
        save()
        break
      end
    end
  end
  
  # Search by employee name 
  def find_by_name(name)
    name_results = []
    search = name.downcase
    employees.each do |employee|
      if employee.full_name.downcase.include?(search)
        name_results.push(employee)
      end
    end
    puts "List of employees that contain (#{search}) anywhere in their name."
    puts "\n"
    name_results.each do |employee|
      puts employee.to_s('last_first')
      employee.print_phone_numbers
      employee.print_addresses
      puts "\n"
    end
    # puts name_results
  end

  # Search by birthday month
  def find_by_birth_month(birth_month)
    birth_month_results = []
    search = birth_month.downcase
    employees.each do |employee|
      if employee.birth_month.downcase.include?(search)
        birth_month_results.push(employee)
      end
    end
    puts "List of employees celebrating a birthday in (#{search.capitalize})"
    puts "\n"
    birth_month_results.each do |employee|
      puts employee.to_s('last_first')
      employee.full_birthday
      puts "\n"
    end
  end 

  # Display entire employee contents
  def print_employee_list
    puts "\e[H\e[2J"
    puts "#### Employee List ####"
    print "\n"
    employees.each do |employee|
      puts employee.to_s('last_first')
      puts employee.short_birthday
    end
  end

  # Add employee method
  def add_employee
    puts "\e[H\e[2J"
    puts "## NEW EMPLOYEE ##"
    puts "\n"
    employee = Employee.new
    print "First name: "
    employee.first_name = gets.chomp
    print "Middle name: "
    employee.middle_name = gets.chomp
    print "Last name: "
    employee.last_name = gets.chomp
    print "Enter birth month (Full month name, ex. July): "
    employee.birth_month = gets.chomp
    print "Enter birth day (Two digits, ex. 04): "
    employee.birth_day = gets.chomp
    print "Enter birth year (Four digits, ex. 1776): "
    employee.birth_year = gets.chomp

    # Sub menu when adding a new employee
    loop do
      puts "Add phone number or address? "
      puts "p:  Add phone number"
      puts "a:  Add address"
      puts "(Any other key to go back)"
      response = gets.chomp.downcase
      case response
      when 'p'
        phone = PhoneNumber.new
        print "Phone number kind (Home, Work, etc): "
        phone.kind = gets.chomp
        print "Number: "
        phone.number = gets.chomp
        employee.phone_numbers.push(phone)
      when 'a'
        address = Address.new
        print "Address Kind (Home, Work, etc): "
        address.kind = gets.chomp
        print "Address line 1: "
        address.street_1 = gets.chomp
        print "Address line 2: "
        address.street_2 = gets.chomp
        print "City: "
        address.city = gets.chomp
        print "State: "
        address.state = gets.chomp
        print "Postal Code: "
        address.postal_code = gets.chomp
        employee.addresses.push(address)
      else
        puts "\e[H\e[2J"
        break
      end
    end

    employees.push(employee)
  end
end

address_book = AddressBook.new
address_book.run